import Coder_Primitive
import Client
import Client_Remote
import Either_Primitives
import Example
import Example_Client
import Example_Client_Remote
import Example_Counter
import Example_Counter_Client
import Example_Counter_Client_Remote
import Example_Counter_HTTP
import Example_Greeting
import Example_Greeting_Client
import Example_Greeting_Client_Remote
import Example_Greeting_HTTP
import HTTP
import HTTP_Client
import HTTP_Coder
import HTTP_Responder
import Parser_Primitive
import Serializer_Primitive
import Testing

@Suite
struct `Example.HTTP Tests` {

    enum Outage: Swift.Error, Equatable {
        case unavailable
    }

    static func client(from value: Example.Counter.Value) -> Example.Client {
        var current = value
        return .init(
            greeting: .init(greet: Example.Greeting.greet),
            counter: .init(
                increment: { limit throws(Example.Counter.Error) in
                    current = try Example.Counter.increment(current, limit: limit)
                    return current
                }
            )
        )
    }

    @Test
    func `HTTP representations round trip domain values`() throws {
        var request: HTTP.Request?
        try Example.Greeting.http.request.serialize(.init("Ada"), into: &request)
        #expect(
            try Example.Greeting.http.request.parse(&request) == .init("Ada")
        )

        var response: HTTP.Response?
        try Example.Counter.http.response.serialize(
            .left(.limit(reached: .init(3))),
            into: &response
        )
        #expect(
            try Example.Counter.http.response.parse(&response)
                == .left(.limit(reached: .init(3)))
        )
    }

    @Test
    func `the refusal representation is named, not intrinsic`() throws {
        // Encoding the refusal as its bare reached-limit number is this
        // surface's choice, so it is reached through the named representation
        // rather than a global conformance.
        let coder = Example.Counter.Error.text
        var body: HTTP.Coding.Body.Text<Example.Counter.Error>.Buffer = nil
        try coder.serialize(.limit(reached: .init(3)), into: &body)
        let canonical = body

        #expect(try coder.parse(&body) == .limit(reached: .init(3)))
        #expect(body == nil)

        var reserialized: HTTP.Coding.Body.Text<Example.Counter.Error>.Buffer = nil
        try coder.serialize(.limit(reached: .init(3)), into: &reserialized)
        #expect(reserialized == canonical)
    }

    @Test
    func `one endpoint drives equivalent local, remote, and responder behavior`() async throws {
        typealias ExternalFailure = Either<HTTP.Coding.Error, HTTP.Coding.Error>

        let local = Self.client(from: .init(0))
        let service = Self.client(from: .init(0))
        let remote = Example.Client.Remote<ExternalFailure>(
            greeting: .init(
                greet: Example.Greeting.http.client(
                    using: Example.Greeting.http.responder(using: service.greeting.greet)
                ).collapsed()
            ),
            counter: .init(
                increment: Example.Counter.http.client(
                    using: Example.Counter.http.responder(using: service.counter.increment)
                )
            )
        )

        let localGreeting = await local.greeting.greet(.init("Ada"))
        let remoteGreeting = try await remote.greeting.greet(.init("Ada"))
        #expect(remoteGreeting == localGreeting)

        let localValue = try await local.counter.increment(limit: .init(1))
        let remoteValue = try await remote.counter.increment(limit: .init(1))
        #expect(remoteValue == localValue)

        await #expect(throws: Example.Counter.Error.limit(reached: .init(1))) {
            _ = try await local.counter.increment(limit: .init(1))
        }

        do throws(Either<ExternalFailure, Example.Counter.Error>) {
            _ = try await remote.counter.increment(limit: .init(1))
            Issue.record("expected a domain refusal")
        } catch {
            #expect(error == .right(.limit(reached: .init(1))))
        }
    }

    @Test
    func `transport and coding failures remain distinguishable`() async {
        let unavailable = Example.Greeting.Client.Remote<Either<Outage, HTTP.Coding.Error>>(
            greet: Example.Greeting.http.client(
                using: HTTP.Client<Outage>(
                    run: { _ throws(Outage) in throw .unavailable }
                )
            ).collapsed()
        )
        do throws(Either<Outage, HTTP.Coding.Error>) {
            _ = try await unavailable.greet(.init("Ada"))
            Issue.record("expected a transport failure")
        } catch {
            #expect(error == .left(.unavailable))
        }

        let invalid = Example.Greeting.Client.Remote<
            Either<Swift.Never, HTTP.Coding.Error>
        >(
            greet: Example.Greeting.http.client(
                using: HTTP.Client<Swift.Never>(
                    run: { _ in .init(status: .notFound) }
                )
            ).collapsed()
        )
        do throws(Either<Swift.Never, HTTP.Coding.Error>) {
            _ = try await invalid.greet(.init("Ada"))
            Issue.record("expected a coding failure")
        } catch {
            #expect(error.value == .response)
        }
    }
}
