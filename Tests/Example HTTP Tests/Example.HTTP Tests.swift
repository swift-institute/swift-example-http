import Byte
import Coder
import Either
import Example
import Example_HTTP
import HTTP
import HTTP_Router
import Operation
import RFC_9110
import Tagged
import Testing

extension Example {
    @Suite
    struct Test {

        @Test
        func `a call prints as a request and routes back`() throws {
            let request = try HTTP.request(Example.self, for: .counter(.increment(limit: 3)))
            #expect(request.method == .post)
            #expect(request.target == HTTP.Target(unchecked: "/counter"))
            #expect(request.content == Array("3".utf8).map(Byte.init(bitPattern:)))

            switch try HTTP.route(Example.self, request) {
            case .counter(.increment(let increment)):
                #expect(increment.input.limit == 3)

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
            #expect(greet.input.name == "Ada")
        }

        @Test
        func `a call's target is available without a request`() throws {
            #expect(
                try HTTP.target(Example.self, for: .counter(.increment(limit: 1)))
                    == HTTP.Target(unchecked: "/counter")
            )
        }

        @Test
        func `an unknown request is a mismatch`() {
            let unknown = HTTP.Router.Request(method: .get, target: HTTP.Target(unchecked: "/nope"))

            #expect(throws: HTTP.Router.Error.mismatch) {
                try HTTP.route(Example.self, unknown)
            }
        }

        @Test
        func `a malformed payload on a matched route is malformed rather than a mismatch`() {
            var malformed = HTTP.Router.Request(method: .post, target: HTTP.Target(unchecked: "/counter"))
            malformed.content = Array("three".utf8).map(Byte.init(bitPattern:))

            #expect(throws: HTTP.Router.Error.malformed) {
                try HTTP.route(Example.self, malformed)
            }
        }

        @Test
        func `a value and a refusal become replies and read back`() throws {
            var value = HTTP.Router.Response.blank
            try Example.Counter.incrementReply.serialize(.right(4), into: &value)
            #expect(try Example.Counter.incrementReply.parse(&value) == .right(4))

            var refusal = HTTP.Router.Response.blank
            try Example.Counter.incrementReply.serialize(.left(.limit(reached: 3)), into: &refusal)
            #expect(try Example.Counter.incrementReply.parse(&refusal) == .left(.limit(reached: 3)))
        }
    }
}
