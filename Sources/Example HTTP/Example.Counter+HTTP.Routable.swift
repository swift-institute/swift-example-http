import Call_Algebra
public import Example
public import Example_Counter
public import Example_Counter_Client
public import HTTP
public import HTTP_Coder
import Parser
import Parser_Skip
import Serializer
import RFC_3986
public import RFC_9110

extension Example.Counter: @retroactive HTTP.Routable {

    public static var route: some HTTP.Routing<Call> {
        HTTP.Route.Case(\.increment) {
            .post
            HTTP.Target.resource(.init(unchecked: "/counter"))
            HTTP.Content(Limit.coder)
        }
    }
}
