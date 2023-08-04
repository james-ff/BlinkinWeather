//
//  APIClient.swift
//  BBApp
//
//  Created by James Bellamy on 29/05/2021.
//

import Combine
import Foundation

protocol APIClientProtocol {
    func perform<T: Codable>(request: APIRequest) -> AnyPublisher<T, APIError>
}

class APIClient: APIClientProtocol {
    // Constant
    private static let description = "APIClient"
    private static let secureURLScheme: String = "https"
    
    // Combine
    private var cancellables: [AnyCancellable] = []
    
    // Dependency
    let session: APIURLSession
    let context: APIContextProtocol
    
    // MARK: Lifecycle
    
    init(
        session: APIURLSession = URLSession.shared,
        context: APIContextProtocol = DefaultAPIContext()
    ) {
        self.session = session
        self.context = context
    }
    
    // MARK: Perform
    
    func perform<T: Decodable>(request: APIRequest) -> AnyPublisher<T, APIError> {
        guard let urlRequest: URLRequest = self.buildURLRequest(from: request) else {
            return Fail(error: APIError.request(description: "URL Request Invalid")).eraseToAnyPublisher()
        }
        print("\(String(describing: self)): Request Starting - \(urlRequest.url?.absoluteString ?? "")")
        let publisher = self.session.dataTaskToPublisher(from: urlRequest)
            .tryMap({ (result) -> Data in try APIClient.validate(data: result.data, response: result.response)})
            .mapError({ (error: Error) in APIError.response(description: error.localizedDescription) })
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError({ (error: Error) in APIError.model(description: error.localizedDescription) })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        publisher.sink(
            receiveCompletion: { result in
                switch result {
                case .finished:
                    print("\(APIClient.description): Request Finished")
                case let .failure(error):
                    print("\(APIClient.description): Request Failed - \(error)")
                }
            },
            receiveValue: { _ in
                print("\(APIClient.description): Response Model Received")
            }
        ).store(in: &self.cancellables)
        return publisher
    }
    
    // MARK: Validate
    
    static private func validate(data: Data, response: URLResponse) throws -> Data {
        guard let response = response as? HTTPURLResponse else {
            throw APIError.response(description: "Response Invalid")
        }
        guard 200..<300 ~= response.statusCode else {
            throw APIError.response(description: "Status Code: \(response.statusCode)")
        }
        return data
    }
    
    // MARK: Build
    
    private func buildURLRequest(from request: APIRequest) -> URLRequest? {
        var components: URLComponents = URLComponents()
        components.scheme = APIClient.secureURLScheme
        components.host = request.host
        components.path = request.path
        components.queryItems = self.buildQueryItems(queryItems: request.queryItems)
        guard let url = components.url else {
            return nil
        }
        var urlRequest: URLRequest = URLRequest(url: url)
        let headers: APIHTTPHeaders = self.buildHeaders(headers: request.headers)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        return urlRequest
    }
    
    private func buildQueryItems(queryItems: [URLQueryItem]) -> [URLQueryItem] {
        context.defaultQueryItems + queryItems
    }
    
    private func buildHeaders(headers: APIHTTPHeaders) -> APIHTTPHeaders {
        context.defaultHeaders.merging(headers, uniquingKeysWith: { (_, new) -> String in new })
    }
}
