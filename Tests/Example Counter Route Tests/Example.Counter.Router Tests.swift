import Byte_Primitive
import Example
import Example_Counter
import Example_Counter_Client
import Example_Counter_Route
import HTTP
import HTTP_Coder
import Parser_Primitive
import Serializer_Primitive
import Testing

private func body(_ text: String) -> [Byte] {
    text.utf8.map(Byte.init)
}

@Test
func `the counter router parses its route to the call`() throws {
    var input = HTTP.Route.Input(
        method: .post,
        path: ["counter"],
        body: body("5")
    )
    let call = try Example.Counter.router.parse(&input)
    #expect(call.eliminate(increment: { $0 }) == Example.Counter.Limit(5))
    #expect(input.isConsumed)
}

@Test
func `the counter router prints the call back onto the route`() throws {
    var printed = HTTP.Route.Input()
    try Example.Counter.router.serialize(.increment(limit: .init(5)), into: &printed)
    #expect(
        printed == HTTP.Route.Input(
            method: .post,
            path: ["counter"],
            body: body("5")
        )
    )
}

@Test
func `the counter router distinguishes a foreign route from a bad payload`() {
    var foreign = HTTP.Route.Input(method: .post, path: ["elsewhere"], body: body("5"))
    #expect(throws: HTTP.Route.Error.noMatch) {
        try Example.Counter.router.parse(&foreign)
    }

    var inadmissible = HTTP.Route.Input(
        method: .post,
        path: ["counter"],
        body: body("not a number")
    )
    #expect(throws: HTTP.Route.Error.malformed) {
        try Example.Counter.router.parse(&inadmissible)
    }
}
