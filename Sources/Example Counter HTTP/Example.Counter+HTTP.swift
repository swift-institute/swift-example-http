public import Example
public import Example_Counter
public import HTTP
public import HTTP_Coder
import RFC_3986

extension Example.Counter {

    public static var http: HTTP.Endpoint<
        HTTP.Coding.Request<HTTP.Coding.Body.Text<Limit>>,
        HTTP.Coding.Response.Choice<
            HTTP.Coding.Body.Text<Error>,
            HTTP.Coding.Body.Text<Value>
        >
    > {
        .init(
            request: .init(
                method: .post,
                target: .origin(path: ["counter"], query: nil),
                content: Limit.coder
            ),
            response: .init(
                refusalStatus: .badRequest,
                refusal: Error.text,
                successStatus: .ok,
                success: Value.coder
            )
        )
    }
}
