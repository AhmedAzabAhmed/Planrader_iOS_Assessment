//
//  HistoricalWeatherView.swift
//  PlanRader_iOS
//
//  Created by Ahmed Azzab Sanad on 14/12/2025.
//

import SwiftUI

struct HistoricalWeatherView: View {
    let city: City
    
    var body: some View {
        List {
            if city.weatherInfoArray.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "tray.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.secondary)
                    Text("No historical data")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
            } else {
                ForEach(city.weatherInfoArray, id: \.objectID) { weatherInfo in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(weatherInfo.weatherDescription?.capitalized ?? "")
                                .font(.headline)
                            Spacer()
                            Text(weatherInfo.requestDate ?? Date(), style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack(spacing: 16) {
                            Label(weatherInfo.temperatureInCelsius, systemImage: "thermometer")
                            Label(weatherInfo.humidityPercentage, systemImage: "humidity.fill")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        
                        Text(weatherInfo.requestDate ?? Date(), style: .time)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("History - \(city.name ?? "")")
        .navigationBarTitleDisplayMode(.inline)
    }
}
