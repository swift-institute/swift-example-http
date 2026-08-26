public import Coder_Primitive
public import Example_Client
public import HTTP
public import HTTP_Coder

extension Example.Counter {
    public static var router: some Coder.`Protocol` {
        HTTP.Request.Coder(Call.self) {
            Case(\.increment) {
                HTTP.Request.Method(.post)
                HTTP.Request.Body(Limit.coder)
            }
        }
    }
}
