public import Coder_Primitive
public import Coder_Algebra
public import Example_Client
public import HTTP
public import HTTP_Coder

extension Example.Counter {
    public struct Responses: Coder.`Protocol` {
        public init() {}

        public var body: some Coder.`Protocol` {
            Coder.Case(Example.Counter.Call.Result.prisms.increment) {
                Coder.OneOf.Sequence {
                    Coder.Case(
                        Swift.Result<Value, Error>.prisms.failure
                    ) {
                        HTTP.Representation(.badRequest, Error.text)
                    }
                    Coder.Case(
                        Swift.Result<Value, Error>.prisms.success
                    ) {
                        HTTP.Representation(.ok, Value.coder)
                    }
                }
            }
        }
    }
}
