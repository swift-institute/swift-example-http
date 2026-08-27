public import Byte_Primitive
import Coder_Algebra
public import Coder_Primitive
import Coder_Parser_Primitives
public import Example
public import Example_Counter
public import HTTP
public import HTTP_Coder
import Parser_Conversion_Primitives
import Parser_Error_Primitives

extension Example.Counter.Limit {
    public struct Coder {}
}

extension Example.Counter.Limit.Coder: Coder_Primitive.Coder.`Protocol` {
    public typealias Failure = HTTP.Coder.Error

    public var body: some Coder_Primitive.Coder.`Protocol`<
        [Byte]?,
        Example.Counter.Limit,
        [Byte]?,
        HTTP.Coder.Error
    > {
        HTTP.Message.Content.Text()
        .map(
            Parser.Conversion.Witness<String, Int, Parser.Conversion.Error>(
                apply: { text throws(Parser.Conversion.Error) in
                    guard let value = Int(text) else {
                        throw .mismatch
                    }
                    return value
                },
                unapply: String.init
            )
        )
        .map(
            Parser.Conversion.Witness<Int, Example.Counter.Limit, Never>(
                apply: Example.Counter.Limit.init,
                unapply: \Example.Counter.Limit.underlying
            )
        )
        .error.map { _ in HTTP.Coder.Error.malformed }
    }
}

extension Example.Counter.Limit: Coder_Primitive.Coder.Codable {
    public static var coder: Coder { Coder() }
}
