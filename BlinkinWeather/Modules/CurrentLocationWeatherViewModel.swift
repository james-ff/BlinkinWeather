//
//  CurrentLocationWeatherViewModel.swift
//  BlinkinWeather
//
//  Created by James Bellamy on 04/08/2023.
//

import Combine
import Foundation

extension CurrentLocationWeatherViewModel {
    enum ViewState: Equatable {
        case requiresLocationAccess
        case notLoaded
        case loading
        case loaded
        case networkError
    }
}

// TODO: Write a unit test suite covering this class, using mocked dependencies according to the provided protocols

class CurrentLocationWeatherViewModel: ObservableObject {
    // Model
    @Published var viewState: ViewState
    @Published var weatherData: OpenWeatherLocationResponse?
    
    // Combine
    private var cancellables: [AnyCancellable] = []
    
    // Dependency
    private let locationService: LocationServiceProtocol
    private let weatherService: OpenWeatherServiceProtocol
    
    // MARK: Lifecycle
    
    init(
        locationService: LocationServiceProtocol = LocationService(),
        weatherService: OpenWeatherServiceProtocol = OpenWeatherService()
    ) {
        self.locationService = locationService
        self.weatherService = weatherService
        // Setup
        if locationService.locationAccessStatus == .accepted {
            viewState = .notLoaded
            fetchWeatherforCurrentLocation()
        } else {
            viewState = .requiresLocationAccess
        }
    }
    
    // MARK: Action
    
    func requestLocationAccess() {
        guard viewState == .requiresLocationAccess else {
            return
        }
        locationService
            .locationAccessStatusPublisher
            .sink { [weak self] status in
                guard let self else { return }
                if locationService.locationAccessStatus == .accepted {
                    viewState = .notLoaded
                }
                
                // TODO: Handle declined status
            }
            .store(in: &cancellables)
        locationService.requestAccess()
    }
    
    func fetchWeatherforCurrentLocation() {
        guard viewState != .loading else {
            return
        }
        guard locationService.locationAccessStatus == .accepted else {
            requestLocationAccess()
            return
        }
        
        viewState = .loading
        
        // TODO: Investigate if it's possible for locationModel to not return, which might require a timeout capability
        
        locationService
            .currentLocationPublisher
            .first()
            .sink { [weak self] locationModel in
                guard let self else { return }
                self.fetchWeather(forLocation: locationModel)
            }
            .store(in: &cancellables)
        
        locationService.requestLocation()
    }
    
    private func fetchWeather(forLocation locationModel: LocationModel) {
        weatherService
            .getWeather(forLocation: locationModel)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    switch completion {
                    case .finished:
                        break
                    case .failure:
                        viewState = .networkError
                    }
                },
                receiveValue: { [weak self] value in
                    guard let self else { return }
                    weatherData = value
                    viewState = .loaded
                }
            )
            .store(in: &cancellables)
    }
}
