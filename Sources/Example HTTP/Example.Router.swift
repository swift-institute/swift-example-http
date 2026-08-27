public import Example_Client
public import HTTP
public import HTTP_Router

extension Example: HTTP.Routable {
    public static var router: some HTTP.Routing<Self> {
        HTTP.Route(\.greeting) {
            Greeting.router
        }
        HTTP.Route(\.counter) {
            Counter.router
        }
    }
}
