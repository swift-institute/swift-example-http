public import Coder
public import Example
public import Example_Greeting
public import Example_Greeting_Signature
public import HTTP
public import HTTP_Coder
import Parser
import Parser_Skip
import Tagged_Coder

extension Example.Greeting: @retroactive HTTP.Routable {

    public static var router: some HTTP.Router.`Protocol`<Call> {
        Call.Router(
            absent: .mismatch,
            greet: HTTP.route {
                .post
                HTTP.Target(unchecked: "/greeting")
                HTTP.Content(Name.self)
            }
        )
    }
}
