public import Example
public import Example_Client
public import HTTP
public import HTTP_Coder
public import HTTP_Route_Derivation
import Optic
import Parser
import Parser_Skip
import Serializer
import RFC_3986
public import RFC_9110

extension Example.Route: HTTP.Routable {

    @Routes
    public static var router: some HTTP.Routing<Self> {
        HTTP.Route.Case(prisms.home) {
            .get
            HTTP.Target.resource(.init(unchecked: "/"))
        }
        HTTP.Route.Case(prisms.api) {
            Example.router
        }
    }
}
