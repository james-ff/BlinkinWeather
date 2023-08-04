//
//  ContentView.swift
//  BlinkinWeather
//
//  Created by James Bellamy on 04/08/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CurrentLocationWeatherView()
                .tabItem {
                    Label("Current Location", systemImage: "location.circle")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
