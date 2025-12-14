//
//  WeatherResponse.swift
//  PlanRader_iOS
//
//  Created by Ahmed Azzab Sanad on 13/12/2025.
//

import Foundation

struct WeatherResponse: Codable {
    let weather: [Weather]?
    let main: Main?
    let name: String?
    let id: Int?
}

struct Weather: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

struct Main: Codable {
    let temp: Double?
    let humidity: Int?
}
