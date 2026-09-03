public import Coder
public import Example
public import Example_Counter
public import Example_Counter_Client
public import HTTP
public import HTTP_Coder
import Operation
import Optic
import Optic_Coder
import Parser
import Parser_Skip
import Serializer
public import RFC_9110

extension Example.Counter.Increment: @retroactive HTTP.Respondable {

    public static var response: some HTTP.Replying<Swift.Result<Output, Failure>> {
        Coder.Case(Swift.Result<Output, Failure>.prisms.failure, absent: .mismatch) {
            .badRequest
            HTTP.Content(Example.Counter.Error.coder)
        }
        Coder.Case(Swift.Result<Output, Failure>.prisms.success, absent: .mismatch) {
            .ok
            HTTP.Content(Example.Counter.Value.coder)
        }
    }
}
