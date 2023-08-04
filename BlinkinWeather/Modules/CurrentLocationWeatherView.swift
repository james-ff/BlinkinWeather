//
//  CurrentLocationWeatherView.swift
//  BlinkinWeather
//
//  Created by James Bellamy on 04/08/2023.
//

import MapKit
import SwiftUI

struct CurrentLocationWeatherView: View {
    @StateObject private var viewModel = CurrentLocationWeatherViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                switch viewModel.viewState {
                case .requiresLocationAccess:
                    VStack(spacing: 20) {
                        Text("App requires access to Location Data")
                        Button("Provide Access") {
                            viewModel.requestLocationAccess()
                        }
                    }
                case .notLoaded:
                    VStack(spacing: 20) {
                        Button("Fetch Weather") {
                            viewModel.fetchWeatherforCurrentLocation()
                        }
                    }
                case .loading:
                    ProgressView {
                        Text("Loading")
                    }
                case .networkError:
                    VStack(spacing: 20) {
                        Text("Network Error")
                        Button("Retry") {
                            viewModel.fetchWeatherforCurrentLocation()
                        }
                    }
                case .loaded:
                    if let weatherData = viewModel.weatherData {
                        WeatherInformationView(weatherData: weatherData)
                    } else {
                        VStack(spacing: 20) {
                            Text("Network Error")
                            Button("Retry") {
                                viewModel.fetchWeatherforCurrentLocation()
                            }
                        }
                    }
                }
            }
            .navigationTitle(viewModel.weatherData?.cityName ?? "Current Location")
        }
    }
}

struct CurrentLocationWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentLocationWeatherView()
    }
}
