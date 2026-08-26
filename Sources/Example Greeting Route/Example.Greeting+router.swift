public import Coder_Primitive
public import Example
public import Example_Greeting
public import Example_Greeting_Client
public import HTTP
public import HTTP_Coder
import Example_Greeting_HTTP
import Parser_Skip_Primitives

extension Example.Greeting {

    /// The one bidirectional route of this domain: `POST /greeting` with the
    /// name as the payload, embedded into `Call.greet` through the derived
    /// prism. Every consumer — server mount, remote client, link
    /// generation — goes through this value; no use site spells the path.
    public static var router: some Coder.`Protocol`<
        HTTP.Route.Input, Example.Greeting.Call, HTTP.Route.Input, HTTP.Route.Error
    > {
        HTTP.Route.Case(
            Example.Greeting.Call.prisms.greet,
            body: Parser.Skip.First(
                HTTP.Route.Method(.post),
                Parser.Skip.First(
                    HTTP.Route.Path.Literal("greeting"),
                    HTTP.Route.Body(Example.Greeting.Name.coder)
                )
            )
        )
    }
}
