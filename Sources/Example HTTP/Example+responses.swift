public import Coder_Primitive
public import Example_Client
public import HTTP
public import HTTP_Coder

extension Example {
    public static var responses: some Coder.`Protocol` {
        HTTP.Response.Coder(Call.self) {
            OneOf {
                Case(\.greeting) {
                    Greeting.responses
                }
                Case(\.counter) {
                    Counter.responses
                }
            }
        }
    }
}
