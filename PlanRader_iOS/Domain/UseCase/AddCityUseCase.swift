//
//  AddCityUseCase.swift
//  PlanRader_iOS
//
//  Created by Ahmed Azzab Sanad on 14/12/2025.
//

import Foundation

protocol AddCityUseCaseProtocol {
    func addCity(name: String) throws
}

final class AddCityUseCase: AddCityUseCaseProtocol {
    let context = PersistenceController.shared.container.viewContext
    private var dataManager: WeatherDataManager
    
    init() {
        dataManager = WeatherDataManager(context: context)
    }
    
    func addCity(name: String) throws {
        try dataManager.addCity(name: name)
    }
}
