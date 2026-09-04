import Byte
import Example
import Example_Counter
import Example_Counter_Signature
import Example_Greeting
import Example_Greeting_Signature
import Example_HTTP
import Example_Signature
import HTTP
import HTTP_Reply
import HTTP_Router
import Operation
import RFC_9110
import Tagged
import Tagged_Standard_Library_Integration
import Tagged_Coder
import Testing

private func bytes(_ text: String) -> [Byte] {
    text.utf8.map(Byte.init(bitPattern:))
}

@Suite
struct `Example.HTTP Tests` {

    @Test
    func `a call prints as a request and routes back`() throws {
        let request = try HTTP.request(Example.self, for: .counter(.increment(limit: 3)))
        #expect(request.method == .post)
        #expect(request.target == HTTP.Target(unchecked: "/counter"))
        #expect(request.content == bytes("3"))

        switch try HTTP.route(Example.self, request) {
        case .counter(.increment(let increment)):
            #expect(increment.input == 3)
        case .greeting:
            Issue.record("expected the counter branch")
        }
    }

    @Test
    func `the greeting operation reaches its own resource`() throws {
        let request = try HTTP.request(Example.self, for: .greeting(.greet("Ada")))
        #expect(request.target == HTTP.Target(unchecked: "/greeting"))

        guard case .greeting(.greet(let greet)) = try HTTP.route(Example.self, request) else {
            Issue.record("expected the greeting operation")
            return
        }
        #expect(greet.input == "Ada")
    }

    @Test
    func `links come from the same router`() throws {
        #expect(
            try HTTP.target(Example.self, for: .counter(.increment(limit: 1)))
                == HTTP.Target(unchecked: "/counter")
        )
    }

    @Test
    func `an unknown request is a mismatch and a bad payload commits`() throws {
        let unknown = HTTP.Router.Request(method: .get, target: HTTP.Target(unchecked: "/nope"))
        #expect(throws: HTTP.Router.Error.mismatch) {
            _ = try HTTP.route(Example.self, unknown)
        }

        var malformed = HTTP.Router.Request(method: .post, target: HTTP.Target(unchecked: "/counter"))
        malformed.content = bytes("three")
        #expect(throws: HTTP.Router.Error.malformed) {
            _ = try HTTP.route(Example.self, malformed)
        }
    }

    @Test
    func `a value and a refusal become responses`() throws {
        let value = try HTTP.Router.Response.ok(Example.Counter.Value(4))
        #expect(value.status == .ok)
        #expect(value.content == bytes("4"))
        #expect(try value.decoded(as: Example.Counter.Value.self) == 4)

        let refusal = try HTTP.Router.Response.badRequest(Example.Counter.Error.limit(reached: 3))
        #expect(refusal.status == .badRequest)
        #expect(refusal.content == bytes("3"))
        #expect(try refusal.decoded(as: Example.Counter.Error.self) == .limit(reached: 3))

        let empty = HTTP.Router.Response.ok()
        #expect(empty.status == .ok)
        #expect(empty.content == nil)
    }
}
