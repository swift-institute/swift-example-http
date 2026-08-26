public import Coder_Primitive
public import Example_Client
public import HTTP
public import HTTP_Coder

extension Example.Counter.Value {
    public struct Coder: Coder.`Protocol` {
        public var body: some Coder.`Protocol` {
            HTTP.Body.Text {
                Int.coder
            }
            .converted(
                to: Example.Counter.Value.self,
                apply: Example.Counter.Value.init,
                unapply: \Example.Counter.Value.underlying
            )
        }
    }
}

extension Example.Counter.Value: Coder.Codable {
    public static var coder: Coder { Coder() }
}
