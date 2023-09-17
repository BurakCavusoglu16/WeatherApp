//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Burak Cavusoğlu on 17.09.2023.
//

import Foundation

// MARK: - WeatherData
struct WeatherData: Codable {
    let weather: [Weather]?
    let main: Main?
    let name: String?
}

// MARK: - Main
struct Main: Codable {
    let temp: Double?
}


// MARK: - Weather
struct Weather: Codable {
    let description: String?
    let icon: String?
}

