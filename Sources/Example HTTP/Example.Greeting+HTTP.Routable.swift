import Call_Algebra
public import Example
public import Example_Greeting
public import Example_Greeting_Client
public import HTTP
public import HTTP_Coder
import Parser
import Parser_Skip
import Serializer
import RFC_3986
public import RFC_9110

extension Example.Greeting: @retroactive HTTP.Routable {

    public static var route: some HTTP.Routing<Call> {
        HTTP.Route.Case(\.greet) {
            .post
            HTTP.Target.resource(.init(unchecked: "/greeting"))
            HTTP.Content(Name.coder)
        }
    }
}
