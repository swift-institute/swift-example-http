public import ASCII
public import ASCII_Decimal_Parser
import ASCII_Decimal_Coder
public import Byte
import Byte_Standard_Library_Integration
import Cursor_Standard_Library_Integration
public import Coder
public import Example
public import Example_Counter
import Parser
import Serializer

extension Example.Counter.Limit: Coder.Codable {

    public struct Coder: Coding {

        public typealias Failure = ASCII.Decimal.Error

        public init() {}

        public var body: some Coding<ArraySlice<Byte>, Example.Counter.Limit, [Byte], ASCII.Decimal.Error> {
            ASCII.Decimal.Coder<ArraySlice<Byte>, [Byte], Swift.Int>().map(
                to: { Example.Counter.Limit($0) },
                from: { $0.underlying }
            )
        }
    }

    public static var coder: Coder { .init() }
}
