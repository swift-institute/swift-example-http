import Byte
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
import RFC_3986
import RFC_9110
import Testing

private func bytes(_ text: String) -> [Byte] {
    text.utf8.map(Byte.init(bitPattern:))
}

@Suite
struct `Example.HTTP Tests` {

    @Test
    func `a call prints as a request and routes back`() throws {
        let request = try HTTP.request(Example.self, for: .counter(.increment(limit: .init(3))))
        #expect(request.method == .post)
        #expect(request.target == .resource(.init(unchecked: "/counter")))
        #expect(request.content == bytes("3"))

        switch try HTTP.route(Example.self, request) {
        case .counter(.increment(let increment)):
            #expect(increment.input == .init(3))
        case .greeting:
            Issue.record("expected the counter branch")
        }
    }

    @Test
    func `the site router embeds the api beside its pages`() throws {
        let api = try HTTP.request(Example.Route.self, for: .api(.greeting(.greet(.init("Ada")))))
        let domain = try HTTP.request(Example.self, for: .greeting(.greet(.init("Ada"))))
        #expect(api == domain)

        let home = try HTTP.request(Example.Route.self, for: .home)
        #expect(home.method == .get)
        #expect(home.content == nil)
        guard case .home = try HTTP.route(Example.Route.self, home) else {
            Issue.record("expected the home page")
            return
        }
        guard case .api(.greeting(.greet(let greet))) = try HTTP.route(Example.Route.self, api) else {
            Issue.record("expected the greeting operation")
            return
        }
        #expect(greet.input == .init("Ada"))
    }

    @Test
    func `links come from the same router`() throws {
        #expect(try HTTP.target(Example.Route.self, for: .home) == .resource(.init(unchecked: "/")))
        #expect(
            try HTTP.target(Example.Route.self, for: .api(.counter(.increment(limit: .init(1)))))
                == .resource(.init(unchecked: "/counter"))
        )
    }

    @Test
    func `an unknown request is a mismatch and a bad payload commits`() throws {
        let unknown = HTTP.Route.Request(method: .get, target: .resource(.init(unchecked: "/nope")))
        #expect(throws: HTTP.Route.Error.mismatch) {
            _ = try HTTP.route(Example.Route.self, unknown)
        }

        var malformed = HTTP.Route.Request(method: .post, target: .resource(.init(unchecked: "/counter")))
        malformed.content = bytes("three")
        #expect(throws: HTTP.Route.Error.malformed) {
            _ = try HTTP.route(Example.Route.self, malformed)
        }
    }

    @Test
    func `a value and a refusal become responses`() throws {
        let value = try HTTP.Route.Response.ok(Example.Counter.Value(4))
        #expect(value.status == .ok)
        #expect(value.content == bytes("4"))
        #expect(try value.decoded(as: Example.Counter.Value.self) == .init(4))

        let refusal = try HTTP.Route.Response.badRequest(Example.Counter.Error.limit(reached: .init(3)))
        #expect(refusal.status == .badRequest)
        #expect(refusal.content == bytes("3"))
        #expect(try refusal.decoded(as: Example.Counter.Error.self) == .limit(reached: .init(3)))

        let empty = HTTP.Route.Response.ok()
        #expect(empty.status == .ok)
        #expect(empty.content == nil)
    }
}
