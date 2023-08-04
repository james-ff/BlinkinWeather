//
//  SecureKeysService.swift
//  BlinkinWeather
//
//  Created by James Bellamy on 04/08/2023.
//

import Foundation

protocol SecureKeysClientProtocol {
    var openWeatherAPIKey: String { get }
}

final class SecureKeysClient: SecureKeysClientProtocol {
    var openWeatherAPIKey: String {
        "060651a1b4abf26f5cb096c2665a5e91" // TODO: Fetch this data from outside of source control (Cocoapod Keys or similar)
    }
}
