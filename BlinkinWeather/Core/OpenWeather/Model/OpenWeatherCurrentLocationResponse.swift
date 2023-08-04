//
//  CurrentLocationWeatherResponse.swift
//  BlinkinWeather
//
//  Created by James Bellamy on 04/08/2023.
//

import CoreLocation
import Foundation

// TODO: Investigate if any fields may require optionality, optional fields were set based on a small number of requests
// NOTE: If one or more fields return nil and are non-optional the whole model will not return, so it is important to be sure

struct OpenWeatherLocationResponse: Codable {
    let cityId: Int
    let cityName: String
    let coordinates: Coordinates
    let weather: [Weather]
    let mainConditions: MainConditions
    let visibility: Int
    let wind: Wind
    let rain: Precipitation?
    var snow: Precipitation?
    let clouds: Clouds
    let system: System
    let timezone: Int
    let dateAndTimeCaptured: Int
    
    enum CodingKeys: String, CodingKey {
        case cityId = "id"
        case cityName = "name"
        case coordinates = "coord"
        case weather = "weather"
        case mainConditions = "main"
        case visibility = "visibility"
        case wind = "wind"
        case rain = "rain"
        case snow = "snow"
        case clouds = "clouds"
        case system = "sys"
        case timezone = "timezone"
        case dateAndTimeCaptured = "dt"
    }
}

extension OpenWeatherLocationResponse {
    struct Coordinates: Codable {
        let longitude: Double
        let latitude: Double
        
        enum CodingKeys: String, CodingKey {
            case longitude = "lon"
            case latitude = "lat"
        }
    }
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct MainConditions: Codable {
        let temperature: Double
        let feelsLike: Double
        let minimumTemperature: Double
        let maximumTemperature: Double
        let airPressure: Double
        let humidity: Double
        let seaLevel: Double?
        let groundLevel: Double?
        
        enum CodingKeys: String, CodingKey {
            case temperature = "temp"
            case feelsLike = "feels_like"
            case minimumTemperature = "temp_min"
            case maximumTemperature = "temp_max"
            case airPressure = "pressure"
            case humidity = "humidity"
            case seaLevel = "sea_level"
            case groundLevel = "grnd_level"
        }
    }
    
    struct Wind: Codable {
        let speed: Double
        let degrees: Double
        let gust: Double?
        
        enum CodingKeys: String, CodingKey {
            case speed = "speed"
            case degrees = "deg"
            case gust = "gust"
        }
    }
    
    struct Precipitation: Codable {
        let oneHour: Double?
        let threeHours: Double?
        
        enum CodingKeys: String, CodingKey {
            case oneHour = "1hr"
            case threeHours = "3h"
        }
    }
    
    struct Clouds: Codable {
        let all: Double
    }
    
    struct System: Codable {
        let type: Int
        let id: Int
        let country: String
        let sunrise: Int
        let sunset: Int
    }
}
