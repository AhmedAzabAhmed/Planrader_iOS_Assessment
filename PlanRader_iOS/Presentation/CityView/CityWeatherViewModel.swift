//
//  CityWeatherViewModel.swift
//  PlanRader_iOS
//
//  Created by Ahmed Azzab Sanad on 13/12/2025.
//

import Foundation

@Observable
final class CityWeatherViewModel {
    
    private let getCityWeatherUseCase: GetCityWeatherUseCaseProtocol
    private let addCityUseCase: AddCityUseCaseProtocol
    private let deleteCityUseCase: DeleteCityUseCaseProtocol
    var cities: [City] = []
    var showAddCityAlert = false
    var newCityName = ""
    var sortOption: SortOption = .latest
    var errorMessage: String?
    var showError = false
    
    init(
        getCityWeatherUseCase: GetCityWeatherUseCaseProtocol = GetCityWeatherUseCase(),
        addCityUseCase: AddCityUseCaseProtocol = AddCityUseCase(),
        deleteCityUseCase: DeleteCityUseCaseProtocol = DeleteCityUseCase()
    ) {
        self.getCityWeatherUseCase = getCityWeatherUseCase
        self.addCityUseCase = addCityUseCase
        self.deleteCityUseCase = deleteCityUseCase
    }
    
    
    func loadCities() {
        cities = getCityWeatherUseCase.fetchCities(sortedBy: sortOption)
    }
    
     func addCity() {
        guard !newCityName.isEmpty else { return }
        
        do {
            try addCityUseCase.addCity(name: newCityName)
            loadCities()
            newCityName = ""
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
     func deleteCities(at offsets: IndexSet) {
        for index in offsets {
            let city = cities[index]
            do {
                try deleteCityUseCase.deleteCity(city)
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
        loadCities()
    }
}
