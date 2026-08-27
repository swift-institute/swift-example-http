public import Example_Client
public import HTTP
public import HTTP_Router

extension Example.Counter: HTTP.Routable {
    public static var router: some HTTP.Routing<Self> {
        HTTP.Target.resource(.init(unchecked: "/counter"))
        HTTP.Method.post
        HTTP.Content(Limit.self)
    }
}
