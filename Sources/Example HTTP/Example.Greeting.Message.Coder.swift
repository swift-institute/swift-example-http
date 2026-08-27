public import Byte_Primitive
import Coder_Algebra
public import Coder_Primitive
import Coder_Parser_Primitives
public import Example
public import Example_Greeting
public import HTTP
public import HTTP_Coder
import Parser_Conversion_Primitives
import Parser_Error_Primitives

extension Example.Greeting.Message {
    public struct Coder {}
}

extension Example.Greeting.Message.Coder: Coder_Primitive.Coder.`Protocol` {
    public typealias Failure = HTTP.Coder.Error

    public var body: some Coder_Primitive.Coder.`Protocol`<
        [Byte]?,
        Example.Greeting.Message,
        [Byte]?,
        HTTP.Coder.Error
    > {
        HTTP.Message.Content.Text().map(
            Parser.Conversion.Witness<String, Example.Greeting.Message, Never>(
                apply: Example.Greeting.Message.init,
                unapply: \Example.Greeting.Message.underlying
            )
        ).error.map { _ in HTTP.Coder.Error.malformed }
    }
}

extension Example.Greeting.Message: Coder_Primitive.Coder.Codable {
    public static var coder: Coder { Coder() }
}
