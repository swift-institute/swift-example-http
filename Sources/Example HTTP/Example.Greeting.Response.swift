public import Byte_Primitive
import Coder_Algebra
public import Coder_Primitive
import Coder_Parser_Primitives
import Example_Client
public import Example
public import Example_Greeting
import Example_Greeting_Client
public import HTTP
public import HTTP_Coder
import Optic_Primitives
import Parser_Error_Primitives
public import RFC_9110

extension Example.Greeting {
    fileprivate struct Coder {}
}

extension Example.Greeting.Coder: Coder_Primitive.Coder.`Protocol` {
    typealias Failure = HTTP.Coder.Error

    var body: some Coder_Primitive.Coder.`Protocol`<
        HTTP.Message.Response<[Byte]>?,
        Swift.Result<Example.Greeting.Message, Swift.Never>,
        HTTP.Message.Response<[Byte]>?,
        HTTP.Coder.Error
    > {
        Coder_Algebra.Coder.Case(
            Swift.Result<
                Example.Greeting.Message,
                Swift.Never
            >.prisms.success
        ) {
            HTTP.Representation(.ok, Example.Greeting.Message.coder)
        }.error.map { _ in HTTP.Coder.Error.malformed }
    }
}

extension Example.Greeting: @retroactive HTTP.Respondable {
    public static var response: some HTTP.Coding<Self, [Byte]> {
        Coder()
    }
}
