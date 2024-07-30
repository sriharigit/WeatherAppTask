//
//  ViewController.swift
//  WeatherAppTask
//
//  Created by srihari ponnapalli on 29/06/24.
//


import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var goodMorningLabel: UILabel!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var recentSearchesTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    
    let weatherViewModel = WeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recentSearchesTableView.delegate = self
        recentSearchesTableView.dataSource = self
        countryTextField.layer.cornerRadius = 8
        recentSearchesTableView.layer.cornerRadius = 8
        searchButton.layer.cornerRadius = 8
        countryTextField.delegate = self
        
        recentSearchesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecentSearchCell")
        countryTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        weatherViewModel.updateUI = { [weak self] weatherData in
            self?.temperatureLabel.text = "\(weatherData.current.temp_c)°C"
            self?.conditionLabel.text = weatherData.current.condition.text
            self?.windSpeedLabel.text = "\(weatherData.current.wind_kph) kph"
            self?.humidityLabel.text = "\(weatherData.current.humidity)%"
            
            self?.updateGreetingLabel()
            self?.recentSearchesTableView.reloadData()
        }
        
        recentSearchesTableView.isHidden = true
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        guard let country = countryTextField.text, !country.isEmpty else { return }
        weatherViewModel.fetchWeather(for: country)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherViewModel.recentSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearchCell", for: indexPath)
        cell.textLabel?.text = weatherViewModel.recentSearches[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCountry = weatherViewModel.recentSearches[indexPath.row]
        countryTextField.text = selectedCountry
        weatherViewModel.fetchWeather(for: selectedCountry)
        recentSearchesTableView.isHidden = true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            recentSearchesTableView.isHidden = false
        } else {
            recentSearchesTableView.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let country = countryTextField.text, !country.isEmpty else { return false }
        textField.resignFirstResponder()
        weatherViewModel.fetchWeather(for: country)
        recentSearchesTableView.isHidden = true
        return true
    }
    
    private func updateGreetingLabel() {
        let currentTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        let dateStr = formatter.string(from: currentTime)
        let timeComponents = dateStr.split(separator: " ")[1].split(separator: ":")
        
        if let hour = Int(timeComponents[0]) {
            if hour < 12 {
                goodMorningLabel.text = "Good morning"
            } else if hour < 18 {
                goodMorningLabel.text = "Good afternoon"
            } else {
                goodMorningLabel.text = "Good evening"
            }
        } else {
            print("Error parsing time")
        }
    }
}
