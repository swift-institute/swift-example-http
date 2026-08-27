public import Byte_Primitive
import Example_Client
public import Example
import Example_Counter
import Example_Counter_Client
import Example_Greeting
import Example_Greeting_Client
public import HTTP
public import HTTP_Coder

extension Example: @retroactive HTTP.Respondable {
    public static var response: some HTTP.Responses<Self, [Byte]> {
        HTTP.Coder.Route(\.greeting) {
            Greeting.response
        }
        HTTP.Coder.Route(\.counter) {
            Counter.response
        }
    }
}
