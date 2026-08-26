public import Coder_Primitive
public import Either_Primitives
public import Example
public import Example_Greeting
public import HTTP
public import HTTP_Coder
import Parser_Primitive
import Serializer_Primitive

extension Example.Greeting.Endpoint {

    public struct Response: Coder.`Protocol` {

        public typealias Input = HTTP.Response?
        public typealias Output = Either<Swift.Never, Example.Greeting.Message>
        public typealias Buffer = HTTP.Response?
        public typealias Failure = HTTP.Coding.Error
        public typealias Body =
            HTTP.Coding.Response.Success<Example.Greeting.Message.Coder>

        public init() {}

        public var body: Body {
            Body(
                status: .ok,
                content: Example.Greeting.Message.Coder()
            )
        }
    }
}
