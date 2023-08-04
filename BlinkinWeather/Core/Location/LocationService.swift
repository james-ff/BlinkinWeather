//
//  LocationService.swift
//  BlinkinWeather
//
//  Created by James Bellamy on 04/08/2023.
//

import Combine
import CoreLocation
import Foundation

enum LocationAccessStatus {
    case notAsked
    case accepted
    case declined
}

protocol LocationServiceProtocol {
    var currentLocationPublisher: AnyPublisher<LocationModel, Never> { get }
    var locationAccessStatusPublisher: AnyPublisher<LocationAccessStatus, Never> { get }
    
    var locationAccessStatus: LocationAccessStatus { get }
    
    func requestAccess()
    func requestLocation()
}

final class LocationService: NSObject, LocationServiceProtocol {
    // Model
    private let currentLocationSubject = PassthroughSubject<LocationModel, Never>()
    var currentLocationPublisher: AnyPublisher<LocationModel, Never> {
        currentLocationSubject.eraseToAnyPublisher()
    }
    
    private let locationAccessStatusSubject: CurrentValueSubject<LocationAccessStatus, Never>
    var locationAccessStatusPublisher: AnyPublisher<LocationAccessStatus, Never> {
        locationAccessStatusSubject.eraseToAnyPublisher()
    }
    var locationAccessStatus: LocationAccessStatus {
        locationAccessStatusSubject.value
    }
    
    // State
    
    // Dependency
    var locationManager: CLLocationManager
    
    // MARK: Lifecycle
    
    init(
        locationManager: CLLocationManager = CLLocationManager()
    ) {
        self.locationManager = locationManager
        self.locationAccessStatusSubject = CurrentValueSubject<LocationAccessStatus, Never>(.notAsked)
        super.init()
        locationManager.delegate = self
        locationAccessStatusSubject.send(getLocationAccessStatus())
        printAuthStatus()
    }
    
    // MARK: Action
    
    func requestAccess() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        guard locationAccessStatusSubject.value == .accepted else { return }
        locationManager.requestLocation()
    }
    
    private func getLocationAccessStatus() -> LocationAccessStatus {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            return .notAsked
        case .authorizedAlways, .authorizedWhenInUse:
            return .accepted
        case .restricted, .denied:
            return .declined
        @unknown default:
            return .declined
        }
    }
    
    private func printAuthStatus() {
        var status: String = ""
        switch locationManager.authorizationStatus {
        case .authorizedAlways:
            status = "authorizedAlways"
        case .notDetermined:
            status = "notDetermined"
        case .restricted:
            status = "restricted"
        case .denied:
            status = "denied"
        case .authorizedWhenInUse:
            status = "authorizedWhenInUse"
        @unknown default:
            status = "unknown"
        }
        print("Status: \(status)")
    }
    
    // TODO: Add capability to listen for changes to location over time
}

extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationAccessStatusSubject.send(getLocationAccessStatus())
        printAuthStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocationSubject.send(LocationModel(location: location))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("CLLocationManagerDelegate Error: \(error.localizedDescription)")
    }
}
