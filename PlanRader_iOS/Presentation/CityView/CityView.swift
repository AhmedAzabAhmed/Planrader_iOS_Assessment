//
//  CityView.swift
//  PlanRader_iOS
//
//  Created by Ahmed Azzab Sanad on 13/12/2025.
//

import SwiftUI
import CoreData

struct CityView: View {
    @State var viewModel = CityWeatherViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.cities.isEmpty {
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
                        ForEach(viewModel.cities, id: \.objectID) { city in
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
                        .onDelete(perform: viewModel.deleteCities)
                    }
                }
            }
            .navigationTitle("Weather Cities")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Button(action: {
                                viewModel.sortOption = option
                                viewModel.loadCities()
                            }) {
                                HStack {
                                    Text(option.rawValue)
                                    if viewModel.sortOption == option {
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
                        viewModel.showAddCityAlert = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("Add City", isPresented: $viewModel.showAddCityAlert) {
                TextField("City Name", text: $viewModel.newCityName)
                    .autocapitalization(.words)
                Button("Cancel", role: .cancel) {
                    viewModel.newCityName = ""
                }
                Button("Add") {
                    viewModel.addCity()
                }
            } message: {
                Text("Enter the name of the city")
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "An unknown error occurred")
            }
            .onAppear {
                viewModel.loadCities()
            }
        }
    }
}
