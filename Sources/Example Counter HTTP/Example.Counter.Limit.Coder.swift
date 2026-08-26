public import Coder_Primitive
public import Example
public import Example_Counter
public import HTTP
public import HTTP_Coder
import Parser_Primitive
import Serializer_Primitive

extension Example.Counter.Limit {

    public struct Coder: Coder_Primitive.Coder.`Protocol` {
        public typealias Body = HTTP.Coding.Body.Text<Example.Counter.Limit>
        public typealias Input = Body.Input
        public typealias Output = Body.Output
        public typealias Buffer = Body.Buffer
        public typealias Failure = Body.Failure

        public init() {}

        public var body: Body {
            Body(
                decode: { text throws(HTTP.Coding.Body.Error) in
                    guard let value = Swift.Int(text) else {
                        throw .invalid
                    }
                    return .init(value)
                },
                encode: { String($0.underlying) }
            )
        }
    }
}
