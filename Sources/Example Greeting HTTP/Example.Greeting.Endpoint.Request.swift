public import Coder_Primitive
public import Example
public import Example_Greeting
public import HTTP
public import HTTP_Coder
import Parser_Primitive
import RFC_3986
import Serializer_Primitive

extension Example.Greeting.Endpoint {

    public struct Request: Coder.`Protocol` {

        public typealias Input = HTTP.Request?
        public typealias Output = Example.Greeting.Name
        public typealias Buffer = HTTP.Request?
        public typealias Failure = HTTP.Coding.Error
        public typealias Body = HTTP.Coding.Request<Example.Greeting.Name.Coder>

        public init() {}

        public var body: Body {
            Body(
                method: .post,
                target: .origin(path: ["greeting"], query: nil),
                content: Example.Greeting.Name.Coder()
            )
        }
    }
}
