public import Coder
public import Either
public import Example
public import HTTP
public import HTTP_Reply
public import HTTP_Router
import Operation
public import RFC_9110
public import Tagged

extension Example.Greeting: @retroactive HTTP::Routable {
    public static var router: some HTTP::Router.`Protocol`<Call> {
        Coder::Case(Call.cases.greet.prism, Call.cases.greet.fold, absent: .mismatch) {
            .post
            HTTP::Target(unchecked: "/greeting")
            HTTP::Content(
                Swift::String.Coder().map(
                    to: { Greet.Input(Name($0)) },
                    from: { $0.name.underlying }
                )
            )
        }
    }
}

extension Example.Greeting {
    public static var greetReply: some Coding<HTTP::Router.Response, Either<Never, Message>, HTTP::Router.Response, HTTP::Router.Error> {
        HTTP::reply {
            HTTP::ok(Swift::String.Coder().map(to: { Message($0) }, from: { $0.underlying }))
        }
    }
}
