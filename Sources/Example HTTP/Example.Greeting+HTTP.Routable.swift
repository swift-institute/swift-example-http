public import Example
public import Example_Greeting
public import Example_Greeting_Client
public import HTTP
public import HTTP_Coder
public import HTTP_Route_Derivation
import Operation
import Optic
import Parser
import Parser_Skip
import Serializer
import RFC_3986
public import RFC_9110

extension Example.Greeting: @retroactive HTTP.Routable {

    @Routes @Remote
    public static var router: some HTTP.Routing<Call> {
        HTTP.Route.Case(\.greet) {
            .post
            HTTP.Target.resource(.init(unchecked: "/greeting"))
            HTTP.Content(Name.coder)
        }
    }
}
