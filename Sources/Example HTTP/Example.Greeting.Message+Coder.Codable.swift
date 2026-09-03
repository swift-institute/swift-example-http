public import Byte
import Byte_Standard_Library_Integration
import Cursor_Standard_Library_Integration
public import Coder
public import Example
public import Example_Greeting
public import HTTP
public import HTTP_Coder
public import RFC_9110
import Parser
import Serializer

extension Example.Greeting.Message: Coder.Codable {

    public struct Coder: Coding {

        public typealias Failure = HTTP.Message.Content.Error

        public init() {}

        public var body: some Coding<ArraySlice<Byte>, Example.Greeting.Message, [Byte], HTTP.Message.Content.Error> {
            HTTP.Message.Content.Text().map(
                to: { Example.Greeting.Message($0) },
                from: { $0.underlying }
            )
        }
    }

    public static var coder: Coder { .init() }
}
