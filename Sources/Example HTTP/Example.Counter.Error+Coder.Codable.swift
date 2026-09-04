public import Byte
public import Coder
public import Example
public import Example_Counter
public import String_Coder
import Tagged_Coder

extension Example.Counter.Error: Coder.Codable {

    public static var coder: some Coding<ArraySlice<Byte>, Self, [Byte], Swift.String.Coder.Error> {
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
