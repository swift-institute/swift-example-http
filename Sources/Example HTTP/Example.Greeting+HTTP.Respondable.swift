public import Coder
public import Example
public import Example_Greeting
public import Example_Greeting_Client
public import HTTP
public import HTTP_Coder
import Operation
import Optic
import Optic_Coder
import Parser
import Parser_Skip
import Serializer
public import RFC_9110

extension Example.Greeting.Greet: @retroactive HTTP.Respondable {

    public static var response: some HTTP.Replying<Swift.Result<Output, Failure>> {
        Coder.Case(Swift.Result<Output, Failure>.prisms.success, absent: .mismatch) {
            .ok
            HTTP.Content(Example.Greeting.Message.coder)
        }
    }
}
