//
//  GetCityWeartherUseCase.swift
//  PlanRader_iOS
//
//  Created by Ahmed Azzab Sanad on 13/12/2025.
//

import Foundation

protocol GetCityWeatherUseCaseProtocol {
    func getCityWearther(by cityName: String) async throws -> WeatherResponse
}

final class GetCityWeatherUseCase: GetCityWeatherUseCaseProtocol {
    let repo: CityWeatherRepoProtocol
    
    init(repo: CityWeatherRepoProtocol = CityWeatherRepo()) {
        self.repo = repo
    }
    
    func getCityWearther(by cityName: String) async throws -> WeatherResponse
    {
        try await repo.getCityWearther(by: cityName)
    }
}
