//
//  APIContext.swift
//  BlinkinWeather
//
//  Created by James Bellamy on 04/08/2023.
//

import Foundation

protocol APIContextProtocol {
    var defaultHeaders: [String: String] { get }
    var defaultQueryItems: [URLQueryItem] { get }
}

struct DefaultAPIContext: APIContextProtocol {
    let defaultHeaders: [String: String] = [
        "Content-Type": "application/json"
    ]
    let defaultQueryItems: [URLQueryItem] = []
}
