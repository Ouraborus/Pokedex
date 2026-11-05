//
//  APIClientTest.swift
//  PokedexTests
//
//  Created by Ouraborus on 4/11/26.
//

import Foundation
import Testing
@testable import Pokedex

final class StubURLProtocol: URLProtocol {
    nonisolated(unsafe) static var handler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    
    override func startLoading() {
        guard let handler = Self.handler else { return }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() { }
}

extension URLSession {
    static var stubbed: URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [StubURLProtocol.self]
        return URLSession(configuration: configuration)
    }
}

@MainActor
@Suite(.serialized)
struct APIClientTest {
    let client = URLSessionAPIClient(session: .stubbed)

    @Test func mapsServerErrors() async {
        StubURLProtocol.handler = { request in
            (HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!, Data())
        }
        
        async #expect(throws: NetworkError.server(statusCode: 500)) {
            let _: PokemonListResponse = client.send(.pokemonList(limit: 1, offset: 1))
        }
    }
    
    @Test func sendsPaginationQuery() async throws {
        StubURLProtocol.handler = { request in
            #expect(request.url?.query()?.contains("offset=40") == true)
            let body = Data(#"{"count":0,"next":null,"results":[]}"#.utf8)
            return (HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!, body)
        }

        let _: PokemonListResponse = try await client.send(.pokemonList(limit: 20, offset: 40))
    }

}
