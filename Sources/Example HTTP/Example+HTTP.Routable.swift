public import Example
public import Example_Client
import Example_Counter
import Example_Counter_Client
import Example_Greeting
import Example_Greeting_Client
public import HTTP
public import HTTP_Coder
public import HTTP_Route_Derivation
import Optic
import Parser
import Parser_Skip
import Serializer

extension Example: @retroactive HTTP.Routable {

    @Routes @Remote
    public static var router: some HTTP.Routing<Call> {
        HTTP.Route.Case(\.greeting) {
            Greeting.router
        }
        HTTP.Route.Case(\.counter) {
            Counter.router
        }
    }
}
