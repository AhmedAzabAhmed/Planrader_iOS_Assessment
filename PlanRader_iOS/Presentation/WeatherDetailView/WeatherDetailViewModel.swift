//
//  WeatherDetailViewModel.swift
//  PlanRader_iOS
//
//  Created by Ahmed Azzab Sanad on 14/12/2025.
//

import Foundation

@Observable
final class WeatherDetailViewModel {
    
    private let fetchAndSaveWeatherUseCase: FetchAndSaveWeatherUseCaseProtocol

    var weatherInfo: WeatherInfo?
    var isLoading = false
    var errorMessage: String?
    var showError = false
    let city: City
    
    init(
        fetchAndSaveWeatherUseCase: FetchAndSaveWeatherUseCaseProtocol = FetchAndSaveWeatherUseCase(),
        city: City
    ) {
        self.fetchAndSaveWeatherUseCase = fetchAndSaveWeatherUseCase
        self.city = city
    }
    
    func fetchWeather() async {
        isLoading = true
        
        do {
            let info = try await fetchAndSaveWeatherUseCase.fetchAndSaveWeather(for: city)
            weatherInfo = info
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
        
        isLoading = false
    }
    
    func weatherIconName(for description: String) -> String {
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
    
    func formatDate(_ date: Date) -> String {
       let formatter = DateFormatter()
       formatter.dateStyle = .medium
       formatter.timeStyle = .short
       return formatter.string(from: date)
   }
}
