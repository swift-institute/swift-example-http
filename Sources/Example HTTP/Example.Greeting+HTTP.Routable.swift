public import Byte_Primitive
import Example_Client
public import Example
public import Example_Greeting
import Example_Greeting_Client
public import HTTP
public import HTTP_Router
import RFC_3986
public import RFC_9110

extension Example.Greeting: @retroactive HTTP.Routable {
    public static var router: some HTTP.Routing<Self, [Byte]> {
        HTTP.Target.resource(.init(unchecked: "/greeting"))
        HTTP.Method.post
        HTTP.Content(Name.self)
    }
}
