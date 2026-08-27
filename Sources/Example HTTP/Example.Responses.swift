public import Coder_Primitive
public import Coder_Algebra
public import Example_Client
public import HTTP
public import HTTP_Coder

extension Example {
    public struct Responses: Coder.`Protocol` {
        public init() {}

        public var body: some Coder.`Protocol` {
            Coder.OneOf.Sequence {
                Coder.Case(Example.Call.Result.prisms.greeting) {
                    Greeting.Responses()
                }
                Coder.Case(Example.Call.Result.prisms.counter) {
                    Counter.Responses()
                }
            }
        }
    }
}
