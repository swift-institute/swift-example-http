public import Coder_Primitive
public import Example
public import Example_Greeting
public import HTTP
public import HTTP_Coder
import Parser_Primitive
import Serializer_Primitive

extension Example.Greeting.Message {

    public struct Coder: Coder_Primitive.Coder.`Protocol` {
        public typealias Body = HTTP.Coding.Body.Text<Example.Greeting.Message>
        public typealias Input = Body.Input
        public typealias Output = Body.Output
        public typealias Buffer = Body.Buffer
        public typealias Failure = Body.Failure

        public init() {}

        public var body: Body {
            Body(
                decode: Example.Greeting.Message.init,
                encode: { $0.underlying }
            )
        }
    }
}
