import Byte_Primitive
import Example
import Example_Greeting
import Example_Greeting_Client
import Example_Greeting_Route
import HTTP
import HTTP_Coder
import Parser_Primitive
import Serializer_Primitive
import Testing

private func body(_ text: String) -> [Byte] {
    text.utf8.map(Byte.init)
}

@Test
func `the greeting router parses its route to the call`() throws {
    var input = HTTP.Route.Input(
        method: .post,
        path: ["greeting"],
        body: body("Ada")
    )
    let call = try Example.Greeting.router.parse(&input)
    #expect(call.eliminate(greet: { $0 }) == Example.Greeting.Name("Ada"))
    #expect(input.isConsumed)
}

@Test
func `the greeting router prints the call back onto the route`() throws {
    var printed = HTTP.Route.Input()
    try Example.Greeting.router.serialize(.greet(.init("Ada")), into: &printed)
    #expect(
        printed == HTTP.Route.Input(
            method: .post,
            path: ["greeting"],
            body: body("Ada")
        )
    )
}

@Test
func `the greeting router distinguishes a foreign route from a bad payload`() {
    var foreign = HTTP.Route.Input(method: .get, path: ["greeting"], body: body("Ada"))
    #expect(throws: HTTP.Route.Error.noMatch) {
        try Example.Greeting.router.parse(&foreign)
    }

    var empty = HTTP.Route.Input(method: .post, path: ["greeting"])
    #expect(throws: HTTP.Route.Error.malformed) {
        try Example.Greeting.router.parse(&empty)
    }
}
