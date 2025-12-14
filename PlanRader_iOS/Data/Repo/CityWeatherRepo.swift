//
//  CityWeatherRepo.swift
//  PlanRader_iOS
//
//  Created by Ahmed Azzab Sanad on 13/12/2025.
//

import Foundation
import CoreData

final class CityWeatherRepo: CityWeatherRepoProtocol {
    
    func getCityWearther(by cityName: String) async throws -> WeatherResponse {
        
        guard let url = URL(string: "\(APIConstants.baseURL)data/2.5/weather?q=\(cityName)&appid=\(APIConstants.key)") else {
            throw(NSError(domain: "Invalid URL", code: -1, userInfo: nil))
        }
        
        let rawData = try await APIManager.shared.request(url: url)
        return try DataProcessor.shared.decode(rawData, to: WeatherResponse.self)
    }
    
    func getWeartherIcon(by id: String) async throws -> Data {
        
        guard let url = URL(string: "\(APIConstants.baseURL)img/w/\(id).png") else {
            throw(NSError(domain: "Invalid URL", code: -1, userInfo: nil))
        }
        
        return try await APIManager.shared.request(url: url)
    }
}

class WeatherDataManager {
    private let context: NSManagedObjectContext
    private let repo: CityWeatherRepoProtocol
    
    init(context: NSManagedObjectContext,
         repo: CityWeatherRepoProtocol = CityWeatherRepo()) {
        self.context = context
        self.repo = repo
    }
    
    /// Adds a new city to CoreData
    func addCity(name: String) throws {
        // Check if city already exists
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name ==[c] %@", name)
        
        if let existingCities = try? context.fetch(fetchRequest), !existingCities.isEmpty {
            return // City already exists
        }
        
        let city = City(context: context)
        city.name = name.capitalized
        
        try context.save()
    }
    
    /// Fetches weather for a city and saves to CoreData
    func fetchAndSaveWeather(for city: City) async throws -> WeatherInfo {
        let weatherResponse = try await repo.getCityWearther(by: city.name ?? "")
        
        // Convert Kelvin to Celsius
        let celsius = (weatherResponse.main?.temp ?? 0) - 273.15
        
        // Check if we already have a weather entry for this minute
        let now = Date()
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: now)
        let hour = calendar.component(.hour, from: now)
        let day = calendar.component(.day, from: now)
        
        let fetchRequest: NSFetchRequest<WeatherInfo> = WeatherInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "city == %@", city)
        
        let existingInfos = try? context.fetch(fetchRequest)
        
        // Check if we have an entry from the same minute
        if let existingInfos = existingInfos {
            for info in existingInfos {
                if let requestDate = info.requestDate {
                    let infoMinute = calendar.component(.minute, from: requestDate)
                    let infoHour = calendar.component(.hour, from: requestDate)
                    let infoDay = calendar.component(.day, from: requestDate)
                    
                    
                    if infoMinute == minute && infoHour == hour && infoDay == day {
                        return info // Return existing entry
                    }
                }
            }
        }
        
        // Create new weather info
        let weatherInfo = WeatherInfo(context: context)
        weatherInfo.weatherDescription = weatherResponse.weather?.first?.description ?? "N/A"
        weatherInfo.temperature = celsius
        weatherInfo.humidity = Int16(weatherResponse.main?.humidity ?? 0)
        weatherInfo.requestDate = now
        weatherInfo.iconId = weatherResponse.weather?.first?.icon
        weatherInfo.city = city
        
        try context.save()
        
        return weatherInfo
    }
    
    /// Deletes a city and all its weather data
    func deleteCity(_ city: City) throws {
        context.delete(city)
        try context.save()
    }
    
    /// Fetches all cities
    func fetchCities(sortedBy sortOption: SortOption) -> [City] {
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \City.name, ascending: true)]
        
        guard let cities = try? context.fetch(fetchRequest) else {
            return []
        }
        
        switch sortOption {
        case .latest:
            return cities.sorted { city1, city2 in
                let date1 = city1.weatherInfoArray.first?.requestDate ?? Date.distantPast
                let date2 = city2.weatherInfoArray.first?.requestDate ?? Date.distantPast
                return date1 > date2
            }
            
        case .oldest:
            return cities.sorted { city1, city2 in
                let date1 = city1.weatherInfoArray.first?.requestDate ?? Date.distantFuture
                let date2 = city2.weatherInfoArray.first?.requestDate ?? Date.distantFuture
                return date1 < date2
            }
        }
    }
    
}

enum SortOption: String, CaseIterable {
    case latest = "Latest"
    case oldest = "Oldest"
}
