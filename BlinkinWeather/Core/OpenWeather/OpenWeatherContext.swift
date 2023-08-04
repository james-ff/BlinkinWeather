//
//  OpenWeatherAPIContext.swift
//  BlinkinWeather
//
//  Created by James Bellamy on 04/08/2023.
//

import Foundation

final class OpenWeatherContext: APIContextProtocol {
    let defaultHeaders: [String: String] = [
        "Content-Type": "application/json"
    ]
    let defaultQueryItems: [URLQueryItem]
    
    // MARK: Lifecycle
    
    init(
        secureKeysClient: SecureKeysClientProtocol = SecureKeysClient()
    ) {
        defaultQueryItems = [
            URLQueryItem(name: "appid", value: secureKeysClient.openWeatherAPIKey)
        ]
    }
}
