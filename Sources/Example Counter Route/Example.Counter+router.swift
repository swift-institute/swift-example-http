public import Coder_Primitive
public import Example
public import Example_Counter
public import Example_Counter_Client
public import HTTP
public import HTTP_Coder
import Example_Counter_HTTP
import Parser_Skip_Primitives

extension Example.Counter {

    /// The one bidirectional route of this domain: `POST /counter` with the
    /// limit as the payload, embedded into `Call.increment` through the
    /// derived prism. Every consumer — server mount, remote client, link
    /// generation — goes through this value; no use site spells the path.
    public static var router: some Coder.`Protocol`<
        HTTP.Route.Input, Example.Counter.Call, HTTP.Route.Input, HTTP.Route.Error
    > {
        HTTP.Route.Case(
            Example.Counter.Call.prisms.increment,
            body: Parser.Skip.First(
                HTTP.Route.Method(.post),
                Parser.Skip.First(
                    HTTP.Route.Path.Literal("counter"),
                    HTTP.Route.Body(Example.Counter.Limit.coder)
                )
            )
        )
    }
}
