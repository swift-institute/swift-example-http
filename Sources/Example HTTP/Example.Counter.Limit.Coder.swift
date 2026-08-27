public import Coder_Primitive
public import Example_Client
public import HTTP
public import HTTP_Coder
public import Parser_Conversion_Primitives

extension Example.Counter.Limit {
    public struct Coder: Coder.`Protocol` {
        public var body: some Coder.`Protocol` {
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
        }
    }
}

extension Example.Counter.Limit: Coder.Codable {
    public static var coder: Coder { Coder() }
}
