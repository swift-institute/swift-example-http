import Byte
import Either
import Example
import Example_Counter
import Example_Greeting
import Example_HTTP
import HTTP
import HTTP_Coder
import Operation
import Optic
import Parser
import Parser_Skip
import Serializer
import RFC_3986
import RFC_9110
import Testing

enum Multiple {
    enum Greet: Operation.Symbol {
        typealias Input = Example.Greeting.Name
        typealias Output = Example.Greeting.Message
        typealias Failure = Never
    }

    enum Increment: Operation.Symbol {
        typealias Input = Example.Counter.Limit
        typealias Output = Example.Counter.Value
        typealias Failure = Example.Counter.Error
    }

    enum Call {
        case greet(Operation.Application<Greet>)
        case increment(Operation.Application<Increment>)
    }
}

extension Multiple.Call: Operation.Coproduct {

    typealias Operations = Either<Multiple.Greet, Multiple.Increment>

    struct Prisms {
        var greet: Optic<Multiple.Call, Multiple.Call, Operation.Application<Multiple.Greet>, Operation.Application<Multiple.Greet>>.Prism {
            .init(
                embed: Multiple.Call.greet,
                extract: { call in if case .greet(let focus) = call { focus } else { nil } }
            )
        }

        var increment: Optic<Multiple.Call, Multiple.Call, Operation.Application<Multiple.Increment>, Operation.Application<Multiple.Increment>>.Prism {
            .init(
                embed: Multiple.Call.increment,
                extract: { call in if case .increment(let focus) = call { focus } else { nil } }
            )
        }
    }

    static var prisms: Prisms { .init() }
}

extension Multiple.Call: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.greet(let left), .greet(let right)): left.input == right.input
        case (.increment(let left), .increment(let right)): left.input == right.input
        default: false
        }
    }
}

extension Multiple: HTTP.Routable {

    static var route: some HTTP.Routing<Call> {
        HTTP.Route.Case(Call.prisms.greet) {
            HTTP.Method.post
            HTTP.Target.resource(.init(unchecked: "/multiple/greet"))
            HTTP.Content(Example.Greeting.Name.coder)
        }
        HTTP.Route.Case(Call.prisms.increment) {
            HTTP.Method.post
            HTTP.Target.resource(.init(unchecked: "/multiple/increment"))
            HTTP.Content(Example.Counter.Limit.coder)
        }
    }
}

@Suite
struct `Example.Operation Tests` {

    @Test
    func `a hand-written coproduct routes through the same cases`() throws {
        for call in [Multiple.Call.increment(.init(.init(7))), .greet(.init(.init("Ada")))] {
            let request = try HTTP.request(Multiple.self, for: call)
            #expect(try HTTP.route(Multiple.self, request) == call)
        }
    }
}
