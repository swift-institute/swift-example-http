public import Example
public import Example_Counter
public import HTTP
public import HTTP_Coder

extension Example.Counter.Error {

    /// The refusal as the bare reached-limit number.
    ///
    /// This is a named representation rather than a `Coder.Codable`
    /// conformance: encoding the refusal as its limit alone is a choice this
    /// HTTP surface makes, not the value's own canonical form, so the global
    /// conformance slot stays free for an intrinsic representation.
    public static var text: HTTP.Coding.Body.Text<Self> {
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
