import Call_Algebra
public import Coder
public import Example
public import Example_Counter
import Example_Counter_Client
public import HTTP
public import HTTP_Coder
import Optic
import Optic_Coder
import Parser
import Parser_Skip
import Serializer
public import RFC_9110

extension Example.Counter: @retroactive HTTP.Respondable {

    public static var response: some HTTP.Replying<Swift.Result<Value, Error>> {
        Coder.Case(Swift.Result<Value, Error>.prisms.failure, absent: .mismatch) {
            HTTP.Status.badRequest
            HTTP.Content(Error.coder)
        }
        Coder.Case(Swift.Result<Value, Error>.prisms.success, absent: .mismatch) {
            HTTP.Status.ok
            HTTP.Content(Value.coder)
        }
    }
}
