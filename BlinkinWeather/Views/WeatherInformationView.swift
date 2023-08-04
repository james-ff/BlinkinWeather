//
//  WeatherInformation.swift
//  BlinkinWeather
//
//  Created by James Bellamy on 04/08/2023.
//

import CoreLocation
import MapKit
import SwiftUI

struct WeatherInformationView: View {
    let weatherData: OpenWeatherLocationResponse
    
    @State private var region = MKCoordinateRegion()
    
    private func setRegion() {
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: weatherData.coordinates.latitude,
                longitude: weatherData.coordinates.longitude
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 0.2,
                longitudeDelta: 0.2
            )
        )
        
        // TODO: Investigate why the map region is not translating to the UI
    }
    
    var body: some View {
        List {
            VStack(alignment: .leading, spacing: 20) {
                Text("Map")
                    .font(.title2)
                Map(coordinateRegion: $region)
                    .frame(height: 200)
            }
            VStack(alignment: .leading, spacing: 20) {
                Text("Overview")
                    .font(.title2)
                ForEach(weatherData.weather, id: \.id) { weather in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Condition")
                                .font(.title3)
                                .foregroundColor(.gray)
                            Text(weather.main)
                                .font(.body)
                        }
                        HStack {
                            Text("Detail")
                                .font(.title3)
                                .foregroundColor(.gray)
                            Text(weather.description)
                                .font(.body)
                        }
                    }
                    
                }
            }
            VStack(alignment: .leading, spacing: 20) {
                Text("Temperature")
                    .font(.title2)
                ProgressView(
                    value: weatherData.mainConditions.temperature - weatherData.mainConditions.minimumTemperature,
                    total: weatherData.mainConditions.maximumTemperature - weatherData.mainConditions.minimumTemperature
                ) {
                    Text("Min: \(String(format: "%.2f", weatherData.mainConditions.minimumTemperature))℃ | Max \(String(format: "%.2f", weatherData.mainConditions.maximumTemperature))℃")
                } currentValueLabel: {
                    Text("Current: \(String(format: "%.2f", weatherData.mainConditions.temperature))℃")
                }
            }
            
            // TODO: Add more rows to display more of the available data
        }
        .listStyle(.plain)
        .onAppear {
            setRegion()
        }
    }
}

struct WeatherInformationView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherInformationView(
            weatherData: OpenWeatherLocationResponse(
                cityId: 1,
                cityName: "Test",
                coordinates: .init(
                    longitude: -122.0312,
                    latitude: 37.3323
                ),
                weather: [
                    .init(
                        id: 800,
                        main: "Clear",
                        description: "clear sky",
                        icon: "01d"
                    )
                ],
                mainConditions: .init(
                    temperature: 27.13,
                    feelsLike: 27.74,
                    minimumTemperature: 17.57,
                    maximumTemperature: 33.03,
                    airPressure: 1014,
                    humidity: 53,
                    seaLevel: nil,
                    groundLevel: nil
                ),
                visibility: 10000,
                wind: .init(
                    speed: 7.72,
                    degrees: 340,
                    gust: nil
                ),
                rain: nil,
                snow: nil,
                clouds: .init(
                    all: 0
                ),
                system: .init(
                    type: 2,
                    id: 2083582,
                    country: "US",
                    sunrise: 1691154897,
                    sunset: 1691205207
                ),
                timezone: -25200,
                dateAndTimeCaptured: 1691187471
            )
        )
    }
}
