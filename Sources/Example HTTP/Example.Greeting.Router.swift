public import Example_Client
public import HTTP
public import HTTP_Router

extension Example.Greeting: HTTP.Routable {
    public static var router: some HTTP.Routing<Self> {
        HTTP.Target.resource(.init(unchecked: "/greeting"))
        HTTP.Method.post
        HTTP.Content(Name.self)
    }
}
