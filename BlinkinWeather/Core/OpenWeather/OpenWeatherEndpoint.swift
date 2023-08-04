//
//  OpenWeatherEndpoint.swift
//  BlinkinWeather
//
//  Created by James Bellamy on 04/08/2023.
//

import Foundation

enum OpenWeatherEndpoint {
    case currentWeather(latitude: Double, longitude: Double)
}

extension OpenWeatherEndpoint: APIRequest {
    var host: String {
        "api.openweathermap.org"
    }
    
    private var pathPrefix: String {
        "data/2.5"
    }
    
    var path: String {
        var path: String = ""
        switch self {
        case .currentWeather:
            path = "weather"
        }
        return "/\(pathPrefix)/\(path)"
    }
    
    var method: APIHTTPMethod {
        switch self {
        case .currentWeather:
            return .get
        }
    }
    
    var headers: [String : String] {
        [:]
    }
    
    var queryItems: [URLQueryItem] {
        var result: [URLQueryItem] = []
        switch self {
        case let .currentWeather(latitude, longitude):
            result.append(
                contentsOf: [
                    URLQueryItem(name: "lat", value: String(latitude)),
                    URLQueryItem(name: "lon", value: String(longitude)),
                    URLQueryItem(name: "units", value: "metric"), // TODO: Enable this to be changed via a settings interface
                    URLQueryItem(name: "lang", value: "en") // TODO: Enable this to be changed via a settings interface
                ]
            )
        }
        return result
    }
    
    var body: Data? {
        nil
    }
}
