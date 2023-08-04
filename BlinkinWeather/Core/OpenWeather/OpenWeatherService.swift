//
//  OpenWeatherService.swift
//  BlinkinWeather
//
//  Created by James Bellamy on 04/08/2023.
//

import Combine
import Foundation

enum OpenWeatherServiceError: Error {
    case apiError(APIError)
}

protocol OpenWeatherServiceProtocol {
    func getWeather(forLocation location: LocationModel) -> AnyPublisher<OpenWeatherLocationResponse, OpenWeatherServiceError>
}

final class OpenWeatherService: OpenWeatherServiceProtocol {
    // Dependency
    let apiClient: APIClientProtocol
    
    // MARK: Lifecycle
    
    init(
        session: APIURLSession = URLSession.shared
    ) {
        // TODO: Externalise APIClient creation to a factory for better unit test isolation
        
        self.apiClient = APIClient(
            session: session,
            context: OpenWeatherContext()
        )
    }
    
    // MARK: Actions
    
    func getWeather(forLocation location: LocationModel) -> AnyPublisher<OpenWeatherLocationResponse, OpenWeatherServiceError> {
        let request: APIRequest = OpenWeatherEndpoint.currentWeather(
            latitude: location.latitude,
            longitude: location.longitude
        )
        let publisher: AnyPublisher<OpenWeatherLocationResponse, OpenWeatherServiceError> = apiClient.perform(request: request)
            .mapError { apiError in OpenWeatherServiceError.apiError(apiError) }
            .eraseToAnyPublisher()
        return publisher
    }
}
