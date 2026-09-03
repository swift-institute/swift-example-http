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

extension Example.Greeting.Name: Coder.Codable {

    public static var coder: some Coding<ArraySlice<Byte>, Self, [Byte], HTTP.Message.Content.Error> {
        HTTP.Message.Content.Text().map(to: { Self($0) }, from: { $0.underlying })
    }
}
