public import ASCII
public import ASCII_Decimal_Parser
public import Byte
public import Byte_Parser
public import Coder
public import Example
public import Example_Counter
import Parser
import Serializer

extension Example.Counter.Error: Coder.Codable {

    public struct Coder: Coding {

        public typealias Failure = ASCII.Decimal.Error

        public init() {}

        public var body: some Coding<Byte.Input, Example.Counter.Error, [Byte], ASCII.Decimal.Error> {
            Example.Counter.Limit.coder.map(
                to: { Example.Counter.Error.limit(reached: $0) },
                from: { error in
                    switch error {
                    case .limit(reached: let limit): limit
                    }
                }
            )
        }
    }

    public static var coder: Coder { .init() }
}
