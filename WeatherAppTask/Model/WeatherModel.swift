//
//  WeatherModel.swift
//  WeatherAppTask
//
//  Created by srihari ponnapalli on 26/07/24.
//

import Foundation

struct WeatherData: Codable {
    let current: CurrentWeather
}

struct CurrentWeather: Codable {
    let temp_c: Double
    let condition: WeatherCondition
    let wind_kph: Double
    let humidity: Int
}

struct WeatherCondition: Codable {
    let text: String
    let icon: String
}
