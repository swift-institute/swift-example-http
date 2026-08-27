public import Byte_Primitive
import Example_Client
public import Example
import Example_Counter
import Example_Counter_Client
import Example_Greeting
import Example_Greeting_Client
public import HTTP
public import HTTP_Router

extension Example: @retroactive HTTP.Routable {
    public static var router: some HTTP.Routes<Self, [Byte]> {
        HTTP.Route(\.greeting) {
            Greeting.router
        }
        HTTP.Route(\.counter) {
            Counter.router
        }
    }
}
