public import Coder
public import Example
public import Example_Counter
public import Example_Counter_Signature
public import HTTP
public import HTTP_Router
import Parser
import Parser_Skip
import RFC_9110
import Tagged_Coder

extension Example.Counter: @retroactive HTTP.Routable {

    public static var router: some HTTP.Router.`Protocol`<Call> {
        Call.Router(
            absent: .mismatch,
            increment: HTTP.route {
                .post
                HTTP.Target(unchecked: "/counter")
                HTTP.Content(Limit.self)
            }
        )
    }
}
