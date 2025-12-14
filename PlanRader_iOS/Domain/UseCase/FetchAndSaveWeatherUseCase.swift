//
//  FetchAndSaveWeatherUseCase.swift
//  PlanRader_iOS
//
//  Created by Ahmed Azzab Sanad on 14/12/2025.
//

import Foundation

protocol FetchAndSaveWeatherUseCaseProtocol {
    func fetchAndSaveWeather(for city: City) async throws -> WeatherInfo
}

final class FetchAndSaveWeatherUseCase: FetchAndSaveWeatherUseCaseProtocol {
    let context = PersistenceController.shared.container.viewContext
    private var dataManager: WeatherDataManager
    
    init() {
        dataManager = WeatherDataManager(context: context)
    }
    
    func fetchAndSaveWeather(for city: City) async throws -> WeatherInfo {
        try await dataManager.fetchAndSaveWeather(for: city)
    }
}
