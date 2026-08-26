public import Coder_Primitive
public import Example_Client
public import HTTP
public import HTTP_Coder

extension Example.Counter {
    public static var responses: some Coder.`Protocol` {
        HTTP.Response.Coder(Call.self) {
            Case(\.increment) {
                OneOf {
                    HTTP.Response.Status(.badRequest) {
                        HTTP.Response.Body(Error.text)
                    }
                    HTTP.Response.Status(.ok) {
                        HTTP.Response.Body(Value.coder)
                    }
                }
            }
        }
    }
}
