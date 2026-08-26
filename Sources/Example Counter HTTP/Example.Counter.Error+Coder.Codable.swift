public import Coder_Primitive
public import Example
public import Example_Counter
public import HTTP
public import HTTP_Coder

extension Example.Counter.Error: Coder.Codable {

    public static var coder: HTTP.Coding.Body.Text<Self> {
        .init(
            decode: { text throws(HTTP.Coding.Body.Error) in
                guard let value = Swift.Int(text) else {
                    throw .invalid
                }
                return .limit(reached: .init(value))
            },
            encode: { refusal in
                switch refusal {
                case .limit(reached: let limit):
                    String(limit.underlying)
                }
            }
        )
    }
}
