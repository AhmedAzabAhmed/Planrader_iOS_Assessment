//
//  DeleteCityUseCase.swift
//  PlanRader_iOS
//
//  Created by Ahmed Azzab Sanad on 14/12/2025.
//

import Foundation

protocol DeleteCityUseCaseProtocol {
    func deleteCity(_ city: City) throws
}

final class DeleteCityUseCase: DeleteCityUseCaseProtocol {
    let context = PersistenceController.shared.container.viewContext
    private var dataManager: WeatherDataManager
    
    init() {
        dataManager = WeatherDataManager(context: context)
    }
    
    func deleteCity(_ city: City) throws {
        try dataManager.deleteCity(city)
    }
}
