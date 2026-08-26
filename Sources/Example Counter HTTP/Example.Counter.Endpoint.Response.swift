public import Coder_Primitive
public import Either_Primitives
public import Example
public import Example_Counter
public import HTTP
public import HTTP_Coder
import Parser_Primitive
import Serializer_Primitive

extension Example.Counter.Endpoint {

    public struct Response: Coder.`Protocol` {

        public typealias Input = HTTP.Response?
        public typealias Output = Either<Example.Counter.Error, Example.Counter.Value>
        public typealias Buffer = HTTP.Response?
        public typealias Failure = HTTP.Coding.Error
        public typealias Body = HTTP.Coding.Response.Choice<
            Example.Counter.Error.Coder,
            Example.Counter.Value.Coder
        >

        public init() {}

        public var body: Body {
            Body(
                refusalStatus: .badRequest,
                refusal: Example.Counter.Error.Coder(),
                successStatus: .ok,
                success: Example.Counter.Value.Coder()
            )
        }
    }
}
