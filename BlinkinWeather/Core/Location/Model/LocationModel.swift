//
//  LocationModel.swift
//  BlinkinWeather
//
//  Created by James Bellamy on 04/08/2023.
//

import Foundation
import MapKit

struct LocationModel {
    let longitude: Double
    let latitude: Double
    
    init(
        location: CLLocation
    ) {
        self.longitude = location.coordinate.longitude
        self.latitude = location.coordinate.latitude
    }
}
