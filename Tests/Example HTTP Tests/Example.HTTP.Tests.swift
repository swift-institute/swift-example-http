import Byte_Primitive
import Call_Algebra
import Coder_Algebra
import Coder_Primitive
import Example
import Example_Client
import Example_Counter
import Example_Counter_Client
import Example_Greeting
import Example_Greeting_Client
import Example_HTTP
import HTTP
import HTTP_Coder
import HTTP_Router
import Optic_Primitives
import RFC_9110
import Testing

private func requireResponseCoverage<Response: HTTP.Responses<Example, [Byte]>>(
    _: Response
) where Response.Coverage == Example.Call.Coverage {}

@Test
func `the router is bidirectional`() throws {
    let router = Example.router
    do {
        let call = Example.Call.greeting(.greet(.init("Ada")))
        var input = try Optional(HTTP.request(Example.self, for: call))
        let output = router.embed(try router.parse(&input))

        #expect(output == call)
        #expect(output[case: \.greeting.greet] == .init("Ada"))
    }
    do {
        let call = Example.Call.counter(.increment(limit: .init(3)))
        var input = try Optional(HTTP.request(Example.self, for: call))

        #expect(router.embed(try router.parse(&input)) == call)
    }
}

@Test
func `operation routers code their exact inputs`() throws {
    do {
        let router = Example.Greeting.router
        let name = Example.Greeting.Name("Ada")
        var request: HTTP.Message.Request<[Byte]>?
        try router.serialize(name, into: &request)
        var input = request

        #expect(try router.parse(&input) == name)
    }
    do {
        let router = Example.Counter.router
        let limit = Example.Counter.Limit(3)
        var request: HTTP.Message.Request<[Byte]>?
        try router.serialize(limit, into: &request)
        var input = request

        #expect(try router.parse(&input) == limit)
    }
}

@Test
func `responses are bidirectional`() throws {
    requireResponseCoverage(Example.response)

    do {
        let result = Swift.Result<
            Example.Greeting.Message,
            Swift.Never
        >.success(.init("Hello, Ada!"))
        let coder = Example.Greeting.response
        var response: HTTP.Message.Response<[Byte]>?
        try coder.serialize(result, into: &response)

        #expect(try coder.parse(&response) == result)
    }
    do {
        let result = Swift.Result<
            Example.Counter.Value,
            Example.Counter.Error
        >.failure(.limit(reached: .init(3)))
        let coder = Example.Counter.response
        var response: HTTP.Message.Response<[Byte]>?
        try coder.serialize(result, into: &response)

        #expect(response?.status == .badRequest)
        #expect(try coder.parse(&response) == result)
    }
}
