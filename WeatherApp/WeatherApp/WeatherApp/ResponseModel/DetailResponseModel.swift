//
//  DetailResponseModel.swift
//  WeatherApp
//
//  Created by Burak Cavusoğlu on 17.09.2023.
//

import Foundation

// MARK: - DetailData
struct DetailResponseModel: Codable {
    let list: [List]?
}


// MARK: - List
struct List: Codable {
    let dtTxt: String?
    let main: Main?
    let weather: [Weather]?
    
   enum CodingKeys: String, CodingKey {
       case dtTxt = "dt_txt"
       case main
        case weather
   }
}
