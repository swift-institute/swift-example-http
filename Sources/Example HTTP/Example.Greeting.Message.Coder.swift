public import Coder_Primitive
public import Example_Client
public import HTTP
public import HTTP_Coder
public import Parser_Conversion_Primitives

extension Example.Greeting.Message {
    public struct Coder: Coder.`Protocol` {
        public var body: some Coder.`Protocol` {
            HTTP.Message.Content.Text().map(
                Parser.Conversion.Witness<String, Example.Greeting.Message, Never>(
                    apply: Example.Greeting.Message.init,
                    unapply: \Example.Greeting.Message.underlying
                )
            )
        }
    }
}

extension Example.Greeting.Message: Coder.Codable {
    public static var coder: Coder { Coder() }
}
