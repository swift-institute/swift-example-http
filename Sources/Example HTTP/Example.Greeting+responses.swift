public import Coder_Primitive
public import Example_Client
public import HTTP
public import HTTP_Coder

extension Example.Greeting {
    public static var responses: some Coder.`Protocol` {
        HTTP.Response.Coder(Call.self) {
            Case(\.greet) {
                HTTP.Response.Status(.ok) {
                    HTTP.Response.Body(Message.coder)
                }
            }
        }
    }
}
