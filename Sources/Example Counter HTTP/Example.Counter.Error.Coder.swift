public import Coder_Primitive
public import Example
public import Example_Counter
public import HTTP
public import HTTP_Coder
import Parser_Primitive
import Serializer_Primitive

extension Example.Counter.Error {

    public struct Coder: Coder_Primitive.Coder.`Protocol` {
        public typealias Body = HTTP.Coding.Body.Text<Example.Counter.Error>
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
                    return .limit(reached: .init(value))
                },
                encode: { refusal in
                    switch refusal {
                    case .limit(reached: let limit):
                        String(limit.underlying)
                    }
                }
            )
        }
    }
}
