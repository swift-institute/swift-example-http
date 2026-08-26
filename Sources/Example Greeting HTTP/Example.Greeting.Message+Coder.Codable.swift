public import Coder_Primitive
public import Example
public import Example_Greeting
public import HTTP
public import HTTP_Coder

extension Example.Greeting.Message: Coder.Codable {

    public static var coder: HTTP.Coding.Body.Text<Self> {
        .init(
            decode: Self.init,
            encode: { $0.underlying }
        )
    }
}
