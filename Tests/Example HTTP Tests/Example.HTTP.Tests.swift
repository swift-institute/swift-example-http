import Example_Client
import Example_HTTP
import HTTP
import Testing

@Test
func `the router is bidirectional`() throws {
    let call = try Example.router.parse(
        HTTP.Request.post(
            path: "/greeting",
            body: "Ada"
        )
    )

    #expect(call[case: \.greeting.greet] == .init("Ada"))
    #expect(
        try Example.router.print(
            .counter(.increment(limit: .init(3)))
        )
            == HTTP.Request.post(path: "/counter", body: "3")
    )
}

@Test
func `responses are bidirectional`() throws {
    let result = Example.Call.Result.greeting(
        .greet(.init("Hello, Ada!"))
    )
    let response = try Example.responses.serialize(result)

    #expect(try Example.responses.parse(response) == result)
}
