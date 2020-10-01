
//  Clima
//  WheaterData.swift

//  Created by Hendy Christian 12/07/2020.
//  Copyright © 2020 Hendy Christian. All rights reserved.

import Foundation

// Below 3 struct it's a protocol

struct WeatherData: Codable{
    let name: String
    let main: Main
    let weather: [Deskripsi]
}

struct Main: Codable{
    let temp: Double
}

struct Deskripsi: Codable {
    let description: String?
    let id: Int
}
