public import Coder_Primitive
public import Example_Client
public import HTTP
public import HTTP_Coder

extension Example {
    public static var router: some Coder.`Protocol` {
        HTTP.Request.Coder(Call.self) {
            OneOf {
                Case(\.greeting) {
                    HTTP.Request.Path { "greeting" }
                    Greeting.router
                }
                Case(\.counter) {
                    HTTP.Request.Path { "counter" }
                    Counter.router
                }
            }
        }
    }
}
