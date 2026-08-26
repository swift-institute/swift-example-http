public import Coder_Primitive
public import Example_Client
public import HTTP
public import HTTP_Coder

extension Example.Greeting.Message {
    public struct Coder: Coder.`Protocol` {
        public var body: some Coder.`Protocol` {
            HTTP.Body.Text().converted(
                to: Example.Greeting.Message.self,
                apply: Example.Greeting.Message.init,
                unapply: \Example.Greeting.Message.underlying
            )
        }
    }
}

extension Example.Greeting.Message: Coder.Codable {
    public static var coder: Coder { Coder() }
}
