public import Example
public import Example_Greeting
public import HTTP
public import HTTP_Coder
import RFC_3986

extension Example.Greeting {

    public static var http: HTTP.Endpoint<
        HTTP.Coding.Request<HTTP.Coding.Body.Text<Name>>,
        HTTP.Coding.Response.Success<HTTP.Coding.Body.Text<Message>>
    > {
        .init(
            request: .init(
                method: .post,
                target: .origin(path: ["greeting"], query: nil),
                content: Name.coder
            ),
            response: .init(
                status: .ok,
                content: Message.coder
            )
        )
    }
}
