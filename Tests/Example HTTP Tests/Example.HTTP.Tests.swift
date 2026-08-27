import Byte_Primitive
import Example_Client
import Example_HTTP
import HTTP
import Testing

@Test
func `the router is bidirectional`() throws {
    let expected = Example.Call.greeting(.greet(.init("Ada")))
    let router = Example.router
    var request: HTTP.Message.Request<[Byte]>?
    try router.serialize(expected, into: &request)
    var input = request
    let call = try router.parse(&input)

    #expect(call == expected)
    #expect(call[case: \.greeting.greet] == .init("Ada"))
    let counter = Example.Call.counter(.increment(limit: .init(3)))
    var counterRequest: HTTP.Message.Request<[Byte]>?
    try router.serialize(counter, into: &counterRequest)
    var counterInput = counterRequest
    #expect(try router.parse(&counterInput) == counter)
}

@Test
func `responses are bidirectional`() throws {
    let result = Example.Call.Result.greeting(
        .greet(.init("Hello, Ada!"))
    )
    let responses = Example.Responses()
    var response: HTTP.Message.Response<[Byte]>?
    try responses.serialize(result, into: &response)

    #expect(try responses.parse(&response) == result)
}
