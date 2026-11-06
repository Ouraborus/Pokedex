//
//  APIClient.swift
//  Pokedex
//
//  Created by Ouraborus on 4/11/26.
//

import Foundation

enum NetworkError: Error, Equatable {
    case decoding
    case invalidURL
    case notConnectedToInternet
    case timedOut
    case server(statusCode: Int)
    case unknown
}

protocol APIClient: Sendable {
    func send<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

struct URLSessionAPIClient: APIClient {
    private let baseURL: URL
    private let session: URLSession
    
    init(
        baseURL: URL = URL(string: "https://pokeapi.co/api/v2")!,
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.session = session
    }
    
    func send<T>(_ endpoint: Endpoint) async throws -> T where T : Decodable {
        // Create Request
        let request = try makeRequest(for: endpoint)
        // Perform Request Capture Response, Throw errors if needed
        let (data, response) = try await perform(request)
        
        guard let response = response as? HTTPURLResponse else { throw NetworkError.unknown }
        guard (200..<300).contains(response.statusCode) else {
            throw NetworkError.server(statusCode: response.statusCode)
        }
        
        // Decode Object
        do {
            return try JSONDecoder.pokeAPI.decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding
        }
    }
    
    func makeRequest(for endpoint: Endpoint) throws -> URLRequest {
        // Create URL
        let url = baseURL.appending(path: endpoint.path)
        
        // Extract URL Components
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            // Throw error
            throw NetworkError.invalidURL
        }
        
        // Add Query Items
        if !endpoint.queryParams.isEmpty {
            urlComponents.queryItems = urlComponents.queryItems ?? [] + endpoint.queryParams
        }
        
        // Build URL Request
        guard let requestUrl = urlComponents.url else { throw NetworkError.invalidURL }

        return URLRequest(url: requestUrl)
    }
    
    func perform(_ request: URLRequest) async throws -> (Data, URLResponse) {
        // Try request and return
        do {
            print("GET", request.url?.absoluteString ?? "")
            return try await session.data(for: request)
        } catch let error as URLError {
            // Throw errors based on response
            switch error.code {
            case .cancelled: throw CancellationError()
            case .notConnectedToInternet: throw NetworkError.notConnectedToInternet
            case .timedOut: throw NetworkError.timedOut
            default: throw NetworkError.unknown
            }
        }
    }
}

extension JSONDecoder {
    static var pokeAPI: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
