import Byte
import Call_Algebra
import Example
import Example_Counter
import Example_Greeting
import Example_HTTP
import HTTP
import HTTP_Coder
import Optic
import Parser
import Parser_Skip
import Serializer
import RFC_3986
import RFC_9110
import Testing

enum Multiple {}

extension Multiple {

    enum Call: Equatable {
        case greet(Example.Greeting.Name)
        case increment(Example.Counter.Limit)
    }
}

extension Multiple.Call {

    enum Branch {
        enum Greet {}
        enum Increment {}
    }

    struct Branches {

        var greet: Call_Algebra.Call.Branch<Multiple.Call, Example.Greeting.Name, Branch.Greet> {
            .init(
                .init(
                    embed: Multiple.Call.greet,
                    extract: { call in
                        switch call {
                        case .greet(let name): name
                        case .increment: nil
                        }
                    }
                )
            )
        }

        var increment: Call_Algebra.Call.Branch<Multiple.Call, Example.Counter.Limit, Branch.Increment> {
            .init(
                .init(
                    embed: Multiple.Call.increment,
                    extract: { call in
                        switch call {
                        case .greet: nil
                        case .increment(let limit): limit
                        }
                    }
                )
            )
        }
    }
}

extension Multiple.Call.Branch.Greet: Call_Algebra.Call.Operation {
    typealias Input = Example.Greeting.Name
    typealias Output = Example.Greeting.Message
    typealias Failure = Never
}

extension Multiple.Call.Branch.Increment: Call_Algebra.Call.Operation {
    typealias Input = Example.Counter.Limit
    typealias Output = Example.Counter.Value
    typealias Failure = Example.Counter.Error
}

extension Multiple.Call: Call_Algebra.Call.`Protocol` {
    typealias Coverage = Call_Algebra.Call.Coverage<Branch.Greet, Branch.Increment>

    static var branches: Branches { .init() }
}

extension Multiple: HTTP.Routable {

    static var route: some HTTP.Routing<Call> {
        HTTP.Route.Case(\.greet) {
            HTTP.Route.Method(.post)
            HTTP.Route.Target(.resource(.init(unchecked: "/multiple/greet")))
            HTTP.Route.Content(Example.Greeting.Name.coder)
        }
        HTTP.Route.Case(\.increment) {
            HTTP.Route.Method(.post)
            HTTP.Route.Target(.resource(.init(unchecked: "/multiple/increment")))
            HTTP.Route.Content(Example.Counter.Limit.coder)
        }
    }
}

@Suite
struct `Example.Operation Tests` {

    @Test
    func `a hand-written coproduct routes through the same cases`() throws {
        for call in [Multiple.Call.increment(.init(7)), .greet(.init("Ada"))] {
            let request = try HTTP.request(Multiple.self, for: call)
            #expect(try HTTP.route(Multiple.self, request) == call)
        }
    }
}
