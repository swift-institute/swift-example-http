public import Byte_Primitive
import Example_Client
public import Example
public import Example_Counter
import Example_Counter_Client
public import HTTP
public import HTTP_Router
import RFC_3986
public import RFC_9110

extension Example.Counter: @retroactive HTTP.Routable {
    public static var router: some HTTP.Routing<Self, [Byte]> {
        HTTP.Target.resource(.init(unchecked: "/counter"))
        HTTP.Method.post
        HTTP.Content(Limit.self)
    }
}
