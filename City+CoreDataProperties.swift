//
//  City+CoreDataProperties.swift
//  PlanRader_iOS
//
//  Created by Ahmed Azzab Sanad on 14/12/2025.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var type: String?
    @NSManaged public var name: String?
    @NSManaged public var weatherInfos: NSSet?

}

// MARK: Generated accessors for weatherInfos
extension City {

    @objc(addWeatherInfosObject:)
    @NSManaged public func addToWeatherInfos(_ value: WeatherInfo)

    @objc(removeWeatherInfosObject:)
    @NSManaged public func removeFromWeatherInfos(_ value: WeatherInfo)

    @objc(addWeatherInfos:)
    @NSManaged public func addToWeatherInfos(_ values: NSSet)

    @objc(removeWeatherInfos:)
    @NSManaged public func removeFromWeatherInfos(_ values: NSSet)

}

extension City : Identifiable {

}


extension City {
    public var weatherInfoArray: [WeatherInfo] {
        let set = weatherInfos as? Set<WeatherInfo> ?? []
        return set.sorted { $0.requestDate ?? Date() > $1.requestDate ?? Date() }
    }
}
