//
//  WeatherInfo+CoreDataProperties.swift
//  PlanRader_iOS
//
//  Created by Ahmed Azzab Sanad on 14/12/2025.
//
//

import Foundation
import CoreData


extension WeatherInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherInfo> {
        return NSFetchRequest<WeatherInfo>(entityName: "WeatherInfo")
    }

    @NSManaged public var weatherDescription: String?
    @NSManaged public var temperature: Double
    @NSManaged public var humidity: Int16
    @NSManaged public var requestDate: Date?
    @NSManaged public var iconId: String?
    @NSManaged public var city: City?

}

// MARK: Generated accessors for city
extension WeatherInfo {

    @objc(addCityObject:)
    @NSManaged public func addToCity(_ value: City)

    @objc(removeCityObject:)
    @NSManaged public func removeFromCity(_ value: City)

    @objc(addCity:)
    @NSManaged public func addToCity(_ values: NSSet)

    @objc(removeCity:)
    @NSManaged public func removeFromCity(_ values: NSSet)

}

extension WeatherInfo : Identifiable {

}

extension WeatherInfo {
    var temperatureInCelsius: String {
        return String(format: "%.1f°C", temperature)
    }
    
    var humidityPercentage: String {
        return "\(humidity)%"
    }
}
