public import Byte_Primitive
public import Coder_Primitive
import Coder_Parser_Primitives
public import Example
public import Example_Counter
public import HTTP
public import HTTP_Coder
import Parser_Conversion_Primitives
import Parser_Error_Primitives

extension Example.Counter.Error {
    public struct Text {}
}

extension Example.Counter.Error.Text: Coder_Primitive.Coder.`Protocol` {
    public typealias Failure = HTTP.Coder.Error

    public var body: some Coder_Primitive.Coder.`Protocol`<
        [Byte]?,
        Example.Counter.Error,
        [Byte]?,
        HTTP.Coder.Error
    > {
        Example.Counter.Limit.coder.map(
            Parser.Conversion.Witness<
                Example.Counter.Limit,
                Example.Counter.Error,
                Never
            >(
                apply: Example.Counter.Error.limit(reached:),
                unapply: { error in
                    switch error {
                    case .limit(reached: let limit):
                        limit
                    }
                }
            )
        ).error.map { _ in HTTP.Coder.Error.malformed }
    }
}

extension Example.Counter.Error {
    public static var text: Text { Text() }
}
