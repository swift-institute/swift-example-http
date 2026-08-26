public import Coder_Primitive
public import Example_Client
public import HTTP
public import HTTP_Coder

extension Example.Greeting.Name {
    public struct Coder: Coder.`Protocol` {
        public var body: some Coder.`Protocol` {
            HTTP.Body.Text().converted(
                to: Example.Greeting.Name.self,
                apply: Example.Greeting.Name.init,
                unapply: \Example.Greeting.Name.underlying
            )
        }
    }
}

extension Example.Greeting.Name: Coder.Codable {
    public static var coder: Coder { Coder() }
}
