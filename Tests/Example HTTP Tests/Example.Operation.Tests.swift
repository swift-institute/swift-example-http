import Byte_Primitive
import Call_Algebra
import Coder_Algebra
import Coder_Primitive
import Example
import Example_Client
import Example_Counter
import Example_Counter_Client
import Example_Greeting
import Example_Greeting_Client
import Example_HTTP
import HTTP
import HTTP_Coder
import HTTP_Router
import Optic_Primitives
import RFC_3986
import RFC_9110
import Testing

private enum Multiple {}

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
        var greet: Call_Algebra.Call.Branch<
            Multiple.Call,
            Example.Greeting.Name,
            Branch.Greet
        > {
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

        var increment: Call_Algebra.Call.Branch<
            Multiple.Call,
            Example.Counter.Limit,
            Branch.Increment
        > {
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

extension Multiple.Call: Call_Algebra.Call.Protocol {
    typealias Coverage = Call_Algebra.Call.Coverage<
        Branch.Greet,
        Branch.Increment
    >

    static var branches: Branches { .init() }
}

extension Multiple: HTTP.Routable {
    static var router: some HTTP.Routes<Self, [Byte]> {
        HTTP.Router.Case(
            \.greet,
            target: .resource(.init(unchecked: "/multiple/greet")),
            method: .post,
            content: Example.Greeting.Name.self
        )
        HTTP.Router.Case(
            \.increment,
            target: .resource(.init(unchecked: "/multiple/increment")),
            method: .post,
            content: Example.Counter.Limit.self
        )
    }
}

extension Multiple: HTTP.Respondable {
    static var response: some HTTP.Responses<Self, [Byte]> {
        HTTP.Coder.Case(
            \.greet,
            Example.Greeting.response
        )
        HTTP.Coder.Case(
            \.increment,
            Example.Counter.response
        )
    }
}

private func requireCoverage<
    Route: HTTP.Routes<Multiple, [Byte]>,
    Response: HTTP.Responses<Multiple, [Byte]>
>(
    route: Route,
    response: Response
) where
    Route.Coverage == Multiple.Call.Coverage,
    Response.Coverage == Multiple.Call.Coverage
{}

private func requireIndex<Route: HTTP.Routes, Response: HTTP.Responses>(
    route: Route,
    response: Response
) where
    Route.Domain == Multiple,
    Response.Domain == Multiple,
    Route.Content == [Byte],
    Response.Content == [Byte],
    Route.Coverage: Call_Algebra.Call.Operation,
    Response.Coverage == Route.Coverage,
    Route.Output == Route.Coverage.Input
{}

@Test
func `operation cases preserve exhaustive domain coverage`() {
    requireCoverage(
        route: Multiple.router,
        response: Multiple.response
    )
}

@Test
func `operation cases round trip the input coproduct`() throws {
    let call = Multiple.Call.increment(.init(7))
    var request = try Optional(HTTP.request(Multiple.self, for: call))
    let router = Multiple.router

    #expect(router.embed(try router.parse(&request)) == call)
}

@Test
func `request and response leaves share one operation index`() {
    let route = HTTP.Router.Case(
        \Multiple.Call.Branches.greet,
        target: .resource(.init(unchecked: "/multiple/greet")),
        method: .post,
        content: Example.Greeting.Name.self
    ).route
    let response = HTTP.Coder.Case(
        \Multiple.Call.Branches.greet,
        Example.Greeting.response
    )

    requireIndex(route: route, response: response)
}
