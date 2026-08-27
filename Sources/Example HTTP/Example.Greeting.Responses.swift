public import Coder_Primitive
public import Coder_Algebra
public import Example_Client
public import HTTP
public import HTTP_Coder

extension Example.Greeting {
    public struct Responses: Coder.`Protocol` {
        public init() {}

        public var body: some Coder.`Protocol` {
            Coder.Case(Example.Greeting.Call.Result.prisms.greet) {
                HTTP.Representation(.ok, Message.coder)
            }
        }
    }
}
