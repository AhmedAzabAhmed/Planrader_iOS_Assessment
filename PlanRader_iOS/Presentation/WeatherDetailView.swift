//
//  WeatherDetailView.swift
//  PlanRader_iOS
//
//  Created by Ahmed Azzab Sanad on 14/12/2025.
//

import SwiftUI

struct WeatherDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var dataManager: WeatherDataManager
    
    let city: City
    
    @State private var weatherInfo: WeatherInfo?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showError = false
    
    init(city: City) {
        self.city = city
        let context = PersistenceController.shared.container.viewContext
        dataManager = WeatherDataManager(context: context)
    }
    
    var body: some View {
        ZStack {
            if isLoading {
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Fetching weather...")
                        .foregroundColor(.secondary)
                }
            } else if let weather = weatherInfo {
                ScrollView {
                    VStack(spacing: 24) {
                        // City name header
                        Text(city.name ?? "")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        // Weather icon and description
                        VStack(spacing: 8) {
                            Image(systemName: weatherIconName(for: weather.weatherDescription ?? ""))
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
                                value: formatDate(weather.requestDate ?? Date())
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
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "An unknown error occurred")
        }
        .task {
            await fetchWeather()
        }
    }
    
    private func fetchWeather() async {
        isLoading = true
        
        do {
            let info = try await dataManager.fetchAndSaveWeather(for: city)
            weatherInfo = info
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
        
        isLoading = false
    }
    
    private func weatherIconName(for description: String) -> String {
        let lowercased = description.lowercased()
        if lowercased.contains("rain") {
            return "cloud.rain.fill"
        } else if lowercased.contains("cloud") {
            return "cloud.fill"
        } else if lowercased.contains("clear") || lowercased.contains("sun") {
            return "sun.max.fill"
        } else if lowercased.contains("snow") {
            return "snow"
        } else if lowercased.contains("thunder") {
            return "cloud.bolt.fill"
        } else {
            return "cloud.sun.fill"
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
}
