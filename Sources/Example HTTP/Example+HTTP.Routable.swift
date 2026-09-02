import Call_Algebra
public import Example
public import Example_Client
import Example_Counter
import Example_Counter_Client
import Example_Greeting
import Example_Greeting_Client
public import HTTP
public import HTTP_Coder
import Parser
import Parser_Skip
import Serializer

extension Example: @retroactive HTTP.Routable {

    public static var route: some HTTP.Routing<Call> {
        HTTP.Route.Case(\.greeting) {
            Greeting.route
        }
        HTTP.Route.Case(\.counter) {
            Counter.route
        }
    }
}
