//
//  ApiKey.swift
//  WeatherApp
//
//  Created by Burak Cavusoğlu on 17.09.2023.
//

import Foundation
import CoreLocation

struct Constant {
    static let apiKey = "0d49ce6ec1ea36aeee9286dea9db4e59"
}

enum Urls {
    case weather(lat: CLLocationDegrees, long: CLLocationDegrees, apiKey: String)
    case weatherDetail(lat: CLLocationDegrees, long: CLLocationDegrees, apiKey: String)
    
    var url: String {
        switch self {
        case .weather(let lat, let long, let apiKey):
            return "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(apiKey)&units=metric"
        case .weatherDetail(let lat, let long, let apiKey):
            return "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(long)&appid=\(apiKey)"
        }
    }
}
