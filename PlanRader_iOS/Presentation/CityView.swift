//
//  CityView.swift
//  PlanRader_iOS
//
//  Created by Ahmed Azzab Sanad on 13/12/2025.
//

import SwiftUI
import CoreData

struct CityView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var dataManager: WeatherDataManager
    @State private var cities: [City] = []
    @State private var showAddCityAlert = false
    @State private var newCityName = ""
    @State private var sortOption: SortOption = .latest
    @State private var errorMessage: String?
    @State private var showError = false
    
    init() {
        let context = PersistenceController.shared.container.viewContext
        dataManager = WeatherDataManager(context: context)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if cities.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "cloud.sun.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        Text("No cities added yet")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        Text("Tap + to add your first city")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                } else {
                    List {
                        ForEach(cities, id: \.objectID) { city in
                            NavigationLink(destination: WeatherDetailView(city: city)) {
                                HStack {
                                    Text(city.name ?? "")
                                        .font(.headline)
                                    
                                    Spacer()
                                    
                                    NavigationLink(destination: HistoricalWeatherView(city: city)) {
                                        Image(systemName: "info.circle")
                                            .foregroundColor(.blue)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .onDelete(perform: deleteCities)
                    }
                }
            }
            .navigationTitle("Weather Cities")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Button(action: {
                                sortOption = option
                                loadCities()
                            }) {
                                HStack {
                                    Text(option.rawValue)
                                    if sortOption == option {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddCityAlert = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("Add City", isPresented: $showAddCityAlert) {
                TextField("City Name", text: $newCityName)
                    .autocapitalization(.words)
                Button("Cancel", role: .cancel) {
                    newCityName = ""
                }
                Button("Add") {
                    addCity()
                }
            } message: {
                Text("Enter the name of the city")
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage ?? "An unknown error occurred")
            }
            .onAppear {
                loadCities()
            }
        }
    }
    
    private func loadCities() {
        cities = dataManager.fetchCities(sortedBy: sortOption)
    }
    
    private func addCity() {
        guard !newCityName.isEmpty else { return }
        
        do {
            try dataManager.addCity(name: newCityName)
            loadCities()
            newCityName = ""
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    private func deleteCities(at offsets: IndexSet) {
        for index in offsets {
            let city = cities[index]
            do {
                try dataManager.deleteCity(city)
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
        loadCities()
    }
}
