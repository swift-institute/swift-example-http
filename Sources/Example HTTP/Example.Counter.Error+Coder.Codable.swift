public import ASCII
public import ASCII_Decimal_Parser
public import Byte
import Byte_Standard_Library_Integration
import Cursor_Standard_Library_Integration
public import Coder
public import Example
public import Example_Counter
import Parser
import Serializer

extension Example.Counter.Error: Coder.Codable {

    public static var coder: some Coding<ArraySlice<Byte>, Self, [Byte], ASCII.Decimal.Error> {
        Example.Counter.Limit.coder.map(
            to: { .limit(reached: $0) },
            from: { error in
                switch error {
                case .limit(reached: let limit): limit
                }
            }
        )
    }
}
