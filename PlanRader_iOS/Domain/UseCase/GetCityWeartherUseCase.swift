//
//  GetCityWeartherUseCase.swift
//  PlanRader_iOS
//
//  Created by Ahmed Azzab Sanad on 13/12/2025.
//

import Foundation

protocol GetCityWeatherUseCaseProtocol {
    func fetchCities(sortedBy sortOption: SortOption) -> [City]
}

final class GetCityWeatherUseCase: GetCityWeatherUseCaseProtocol {
    let context = PersistenceController.shared.container.viewContext
    private var dataManager: WeatherDataManager
    
    init() {
        dataManager = WeatherDataManager(context: context)
    }
    
    func fetchCities(sortedBy sortOption: SortOption) -> [City] {
        dataManager.fetchCities(sortedBy: sortOption)
    }
}
