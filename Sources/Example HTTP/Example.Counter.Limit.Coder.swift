public import Coder_Primitive
public import Example_Client
public import HTTP
public import HTTP_Coder

extension Example.Counter.Limit {
    public struct Coder: Coder.`Protocol` {
        public var body: some Coder.`Protocol` {
            HTTP.Body.Text {
                Int.coder
            }
            .converted(
                to: Example.Counter.Limit.self,
                apply: Example.Counter.Limit.init,
                unapply: \Example.Counter.Limit.underlying
            )
        }
    }
}

extension Example.Counter.Limit: Coder.Codable {
    public static var coder: Coder { Coder() }
}
