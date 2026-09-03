import Byte
import Either
import Example
import Example_Client
import Example_Counter
import Example_Counter_Client
import Example_Greeting
import Example_Greeting_Client
import Example_HTTP
import HTTP
import HTTP_Coder
import Operation
import Optic
import Parser
import RFC_3986
import RFC_9110
import Serializer
import Testing

private func bytes(_ text: String) -> [Byte] {
    text.utf8.map(Byte.init(bitPattern:))
}

private func input<Call, Index: Operation.Symbol>(
    _ prism: Optic<Call, Call, Operation.Application<Index>, Operation.Application<Index>>.Prism,
    of call: Call
) -> Index.Input? where Index.Input: Copyable & Escapable {
    let matched = prism.match(call)
    switch consume matched {
    case .right(let application): return application.input
    case .left: return nil
    }
}

@Suite
struct `Example.HTTP Tests` {

    @Test
    func `the root router is bidirectional over both domains`() throws {
        let greeting = Example.Call.greeting(.greet(.init("Ada")))
        let greetingRequest = try HTTP.request(Example.self, for: greeting)
        let greetingRequestAgain = try HTTP.request(Example.self, for: greeting)
        #expect(greetingRequest.method == .post)
        #expect(greetingRequest.target == .resource(.init(unchecked: "/greeting")))
        #expect(greetingRequest.content == bytes("Ada"))
        #expect(greetingRequestAgain == greetingRequest)
        let routedGreeting = try HTTP.route(Example.self, greetingRequest)
        let greetingBranch = Example.Call.prisms.greeting.match(routedGreeting)
        switch consume greetingBranch {
        case .right(let call):
            #expect(input(Example.Greeting.Call.prisms.greet, of: call) == .init("Ada"))
        case .left:
            Issue.record("expected the greeting branch")
        }

        let counter = Example.Call.counter(.increment(limit: .init(3)))
        let counterRequest = try HTTP.request(Example.self, for: counter)
        #expect(counterRequest.target == .resource(.init(unchecked: "/counter")))
        #expect(counterRequest.content == bytes("3"))
        let routedCounter = try HTTP.route(Example.self, counterRequest)
        let counterBranch = Example.Call.prisms.counter.match(routedCounter)
        switch consume counterBranch {
        case .right(let call):
            #expect(input(Example.Counter.Call.prisms.increment, of: call) == .init(3))
        case .left:
            Issue.record("expected the counter branch")
        }
    }

    @Test
    func `operation routes code their exact inputs`() throws {
        var request = HTTP.Route.Request.blank
        try Example.Greeting.route.serialize(.greet(.init("Ada")), into: &request)
        var input = request
        #expect(Example_HTTP_Tests.input(Example.Greeting.Call.prisms.greet, of: try Example.Greeting.route.parse(&input)) == .init("Ada"))
        #expect(input.content == nil)

        var counter = HTTP.Route.Request.blank
        try Example.Counter.route.serialize(.increment(limit: .init(3)), into: &counter)
        var counterInput = counter
        #expect(Example_HTTP_Tests.input(Example.Counter.Call.prisms.increment, of: try Example.Counter.route.parse(&counterInput)) == .init(3))
    }

    @Test
    func `an unknown request is a mismatch and a bad payload commits`() throws {
        let unknown = HTTP.Route.Request(method: .get, target: .resource(.init(unchecked: "/nope")))
        #expect(throws: HTTP.Route.Error.mismatch) {
            _ = try HTTP.route(Example.self, unknown)
        }

        var malformed = HTTP.Route.Request(method: .post, target: .resource(.init(unchecked: "/counter")))
        malformed.content = bytes("three")
        #expect(throws: HTTP.Route.Error.malformed) {
            _ = try HTTP.route(Example.self, malformed)
        }
    }

    @Test
    func `responses are bidirectional`() throws {
        var greeting = HTTP.Route.Response.blank
        try Example.Greeting.Greet.response.serialize(.success(.init("Hello, Ada!")), into: &greeting)
        #expect(greeting.status == .ok)
        #expect(greeting.content == bytes("Hello, Ada!"))
        var greetingInput = greeting
        #expect(try Example.Greeting.Greet.response.parse(&greetingInput) == .success(.init("Hello, Ada!")))

        var refusal = HTTP.Route.Response.blank
        try Example.Counter.Increment.response.serialize(.failure(.limit(reached: .init(3))), into: &refusal)
        #expect(refusal.status == .badRequest)
        #expect(refusal.content == bytes("3"))
        var refusalInput = refusal
        #expect(try Example.Counter.Increment.response.parse(&refusalInput) == .failure(.limit(reached: .init(3))))

        var value = HTTP.Route.Response.blank
        try Example.Counter.Increment.response.serialize(.success(.init(4)), into: &value)
        #expect(value.status == .ok)
        var valueInput = value
        #expect(try Example.Counter.Increment.response.parse(&valueInput) == .success(.init(4)))
    }
}
