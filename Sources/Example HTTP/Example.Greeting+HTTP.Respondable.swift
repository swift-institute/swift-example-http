import Call_Algebra
public import Coder
public import Example
public import Example_Greeting
import Example_Greeting_Client
public import HTTP
public import HTTP_Coder
import Optic
import Optic_Coder
import Parser
import Parser_Skip
import Serializer
public import RFC_9110

extension Example.Greeting: @retroactive HTTP.Respondable {

    public static var response: some HTTP.Replying<Swift.Result<Message, Swift.Never>> {
        Coder.Case(Swift.Result<Message, Swift.Never>.prisms.success, absent: .mismatch) {
            HTTP.Status.ok
            HTTP.Content(Message.coder)
        }
    }
}
