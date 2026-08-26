public import Coder_Primitive
public import Example_Client
public import HTTP
public import HTTP_Coder

extension Example.Counter.Error {
    public struct Text: Coder.`Protocol` {
        public var body: some Coder.`Protocol` {
            Example.Counter.Limit.coder.converted(
                to: Example.Counter.Error.self,
                apply: Example.Counter.Error.limit(reached:),
                unapply: { error in
                    switch error {
                    case .limit(reached: let limit):
                        limit
                    }
                }
            )
        }
    }

    public static var text: Text { Text() }
}
