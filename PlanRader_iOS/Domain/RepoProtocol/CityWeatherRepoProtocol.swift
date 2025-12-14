//
//  CityWeatherRepoProtocol.swift
//  PlanRader_iOS
//
//  Created by Ahmed Azzab Sanad on 13/12/2025.
//

import Foundation

protocol CityWeatherRepoProtocol {
    func getCityWearther(by cityName: String) async throws -> WeatherResponse
}
