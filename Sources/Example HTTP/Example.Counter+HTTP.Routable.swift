public import Byte
public import Coder
public import Either
public import Example
public import HTTP
public import HTTP_Reply
public import HTTP_Router
import Operation
public import RFC_9110
public import Tagged

extension Example.Counter: @retroactive HTTP::Routable {
    public static var router: some HTTP::Router.`Protocol`<Call> {
        Coder::Case(Call.cases.increment.prism, Call.cases.increment.fold, absent: .mismatch) {
            .post
            HTTP::Target(unchecked: "/counter")
            HTTP::Content(
                Swift::String.Coder.Lossless<Swift::Int>().map(
                    to: { Increment.Input(limit: Limit($0)) },
                    from: { $0.limit.underlying }
                )
            )
        }
    }
}

extension Example.Counter {
    public static var incrementReply: some Coding<HTTP::Router.Response, Either<Error, Value>, HTTP::Router.Response, HTTP::Router.Error> {
        HTTP::reply {
            HTTP::ok(Swift::String.Coder.Lossless<Swift::Int>().map(to: { Value($0) }, from: { $0.underlying }))
            HTTP::badRequest(Error.coder)
        }
    }
}

extension Example.Counter.Error {
    public static var coder: some Coding<ArraySlice<Byte>, Self, [Byte], Swift::String.Coder.Error> {
        Swift::String.Coder.Lossless<Swift::Int>().map(
            to: { Example.Counter.Error.limit(reached: Example.Counter.Limit($0)) },
            from: { error in
                switch error {
                case .limit(reached: let limit): limit.underlying
                }
            }
        )
    }
}
