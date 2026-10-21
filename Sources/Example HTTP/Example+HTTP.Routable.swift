public import Coder
public import Example
public import HTTP
public import HTTP_Router

extension Example: @retroactive HTTP::Routable {
    public static var router: some HTTP::Router.`Protocol`<Call> {
        Coder::Case(Call.cases.greeting.prism, Call.cases.greeting.fold, absent: .mismatch) {
            Greeting.router
        }
        Coder::Case(Call.cases.counter.prism, Call.cases.counter.fold, absent: .mismatch) {
            Counter.router
        }
    }
}
