//
//  URLSession+APISession.swift
//  BBApp
//
//  Created by James Bellamy on 29/05/2021.
//

import Combine
import Foundation

protocol APIURLSession {
    func dataTaskToPublisher(from urlRequest: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}

extension URLSession: APIURLSession {
    func dataTaskToPublisher(from urlRequest: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        self.dataTaskPublisher(for: urlRequest).eraseToAnyPublisher()
    }
}
