public import Byte_Primitive
import Coder_Algebra
public import Coder_Primitive
import Coder_Parser_Primitives
import Example_Client
public import Example
public import Example_Counter
import Example_Counter_Client
public import HTTP
public import HTTP_Coder
import Optic_Primitives
import Parser_Error_Primitives
public import RFC_9110

extension Example.Counter {
    fileprivate struct Coder {}
}

extension Example.Counter.Coder: Coder_Primitive.Coder.`Protocol` {
    typealias Failure = HTTP.Coder.Error

    var body: some Coder_Primitive.Coder.`Protocol`<
        HTTP.Message.Response<[Byte]>?,
        Swift.Result<Example.Counter.Value, Example.Counter.Error>,
        HTTP.Message.Response<[Byte]>?,
        HTTP.Coder.Error
    > {
        Coder_Algebra.Coder.OneOf.Sequence {
            Coder_Algebra.Coder.Case(
                Swift.Result<
                    Example.Counter.Value,
                    Example.Counter.Error
                >.prisms.failure
            ) {
                HTTP.Representation(
                    .badRequest,
                    Example.Counter.Error.text
                )
            }
            Coder_Algebra.Coder.Case(
                Swift.Result<
                    Example.Counter.Value,
                    Example.Counter.Error
                >.prisms.success
            ) {
                HTTP.Representation(
                    .ok,
                    Example.Counter.Value.coder
                )
            }
        }.error.map { _ in HTTP.Coder.Error.malformed }
    }
}

extension Example.Counter: @retroactive HTTP.Respondable {
    public static var response: some HTTP.Coding<Self, [Byte]> {
        Coder()
    }
}
