public import ASCII
public import ASCII_Decimal_Parser
import ASCII_Decimal_Coder
public import Byte
public import Byte_Parser
public import Coder
public import Example
public import Example_Counter
import Parser
import Serializer

extension Example.Counter.Value: Coder.Codable {

    public struct Coder: Coding {

        public typealias Failure = ASCII.Decimal.Error

        public init() {}

        public var body: some Coding<Byte.Input, Example.Counter.Value, [Byte], ASCII.Decimal.Error> {
            ASCII.Decimal.Coder<Byte.Input, [Byte], Swift.Int>().map(
                to: { Example.Counter.Value($0) },
                from: { $0.underlying }
            )
        }
    }

    public static var coder: Coder { .init() }
}
