//
//  WeatherDetailView.swift
//  PlanRader_iOS
//
//  Created by Ahmed Azzab Sanad on 14/12/2025.
//

import SwiftUI

struct WeatherDetailView: View {
    
    @State var viewModel: WeatherDetailViewModel
    let city: City
    
    init(city: City) {
        self.city = city
        viewModel = WeatherDetailViewModel(city: city)
    }
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Fetching weather...")
                        .foregroundColor(.secondary)
                }
            } else if let weather = viewModel.weatherInfo {
                ScrollView {
                    VStack(spacing: 24) {
                        // City name header
                        Text(city.name ?? "")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        // Weather icon and description
                        VStack(spacing: 8) {
                            Image(systemName: viewModel.weatherIconName(for: weather.weatherDescription ?? ""))
                                .font(.system(size: 80))
                                .foregroundColor(.blue)
                            
                            Text(weather.weatherDescription?.capitalized ?? "")
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                        .padding()
                        
                        // Weather details
                        VStack(spacing: 16) {
                            WeatherDetailRow(
                                icon: "thermometer",
                                title: "Temperature",
                                value: weather.temperatureInCelsius
                            )
                            
                            WeatherDetailRow(
                                icon: "humidity.fill",
                                title: "Humidity",
                                value: weather.humidityPercentage
                            )
                            
                            WeatherDetailRow(
                                icon: "clock.fill",
                                title: "Last Updated",
                                value: viewModel.formatDate(weather.requestDate ?? Date())
                            )
                        }
                        .padding()
                        
                        // View history button
                        NavigationLink(destination: HistoricalWeatherView(city: city)) {
                            HStack {
                                Image(systemName: "clock.arrow.circlepath")
                                Text("View History")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                }
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 60))
                        .foregroundColor(.orange)
                    Text("Unable to load weather data")
                        .font(.title3)
                }
            }
        }
        .navigationTitle("Weather Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "An unknown error occurred")
        }
        .task {
            await viewModel.fetchWeather()
        }
    }
}
