public import Example
import Example_Counter
import Example_Greeting
public import Example_Signature
public import HTTP
public import HTTP_Router

extension Example: @retroactive HTTP.Routable {

    public static var router: some HTTP.Router.`Protocol`<Call> {
        Call.Router(
            absent: .mismatch,
            greeting: Greeting.router,
            counter: Counter.router
        )
    }
}
