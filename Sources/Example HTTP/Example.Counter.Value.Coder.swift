public import Coder_Primitive
public import Example_Client
public import HTTP
public import HTTP_Coder
public import Parser_Conversion_Primitives

extension Example.Counter.Value {
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
                Parser.Conversion.Witness<Int, Example.Counter.Value, Never>(
                    apply: Example.Counter.Value.init,
                    unapply: \Example.Counter.Value.underlying
                )
            )
        }
    }
}

extension Example.Counter.Value: Coder.Codable {
    public static var coder: Coder { Coder() }
}
