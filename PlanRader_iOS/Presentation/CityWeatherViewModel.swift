//
//  CityWeatherViewModel.swift
//  PlanRader_iOS
//
//  Created by Ahmed Azzab Sanad on 13/12/2025.
//

import Foundation

@Observable
final class CityWeatherViewModel {
    
    private let useCase: GetCityWeatherUseCaseProtocol
    var cityList: [WeatherResponse] = []
    var cityModel: WeatherResponse?
    
    init(useCase: GetCityWeatherUseCaseProtocol = GetCityWeatherUseCase()) {
        self.useCase = useCase
        getCityWeather(for: "London")
    }
    
    func getCityWeather(for city: String) {
        Task {
            do {
                cityModel = try await useCase.getCityWearther(by: city)
            } catch {
                print(error)
            }
        }
    }
}
