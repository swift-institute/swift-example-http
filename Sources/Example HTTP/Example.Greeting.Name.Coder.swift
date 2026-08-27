public import Coder_Primitive
public import Example_Client
public import HTTP
public import HTTP_Coder
public import Parser_Conversion_Primitives

extension Example.Greeting.Name {
    public struct Coder: Coder.`Protocol` {
        public var body: some Coder.`Protocol` {
            HTTP.Message.Content.Text().map(
                Parser.Conversion.Witness<String, Example.Greeting.Name, Never>(
                    apply: Example.Greeting.Name.init,
                    unapply: \Example.Greeting.Name.underlying
                )
            )
        }
    }
}

extension Example.Greeting.Name: Coder.Codable {
    public static var coder: Coder { Coder() }
}
