//
//  APIRequest.swift
//  BBApp
//
//  Created by James Bellamy on 29/05/2021.
//

import Foundation

protocol APIRequest {
    var host: String { get }
    var path: String { get }
    var method: APIHTTPMethod { get }
    var headers: [String: String] { get }
    var queryItems: [URLQueryItem] { get }
    var body: Data? { get }
}

extension APIRequest {
    func integerQueryItem(name: String, value: Int) -> URLQueryItem {
        return URLQueryItem(name: name, value: String(describing: value))
    }
    func optionalStringQueryItem(name: String, value: String?) -> URLQueryItem? {
        guard let value = value, value.isEmpty == false else { return nil }
        return URLQueryItem(name: name, value: value)
    }
}
