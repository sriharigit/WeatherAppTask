//
//  WeatherViewModel.swift
//  WeatherAppTask
//
//  Created by srihari ponnapalli on 26/07/24.
//

import Foundation

class WeatherViewModel {
    
    var weatherData: WeatherData? {
        didSet {
            guard let weatherData = weatherData else { return }
            updateUI?(weatherData)
        }
    }
    
    var recentSearches: [String] {
        get {
            return UserDefaults.standard.array(forKey: "recentSearches") as? [String] ?? []
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "recentSearches")
        }
    }
    
    var updateUI: ((WeatherData) -> Void)?
    
    func fetchWeather(for country: String) {
        let apiKey = "d5d03b2aa8d94e6eb52135020242806"
        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(country)&aqi=no"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                DispatchQueue.main.async {
                    self.weatherData = weatherData
                    self.saveRecentSearch(country: country)
                }
            } catch {
                print("Failed to decode JSON")
            }
        }.resume()
    }
    
    private func saveRecentSearch(country: String) {
        if !recentSearches.contains(country) {
            var searches = recentSearches
            searches.append(country)
            recentSearches = searches
        }
    }
}
