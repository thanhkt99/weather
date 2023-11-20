//
//  WeatherInteractor.swift
//  weather_with_animation
//
//  Created by Tien Thanh on 11/17/23.
//

import Foundation
import UIKit

class WeatherInteractor: PresenterToInteractorWeatherProtocol {
    var weatherPresenter: InteractorToPresenterWeatherProtocol?
    
    func getCurrentWeather(cityName: String) {
        let url: URL = URL(string: "\(URLs.https)\(URLs.domain)\(Paths.weatherCurrent)?city=\(cityName)&key=\(Constants.weatherKey)") ?? URL(fileURLWithPath: "")
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if error != nil || data == nil {
                print("Error \(String(describing: error?.localizedDescription))")
                return
            }
            do {
                let responseData = try JSONDecoder().decode(WeatherResponse.self, from: data ?? Data())
                var weathers = [Weather]()
                if let responseList = responseData.data {
                    weathers = responseList
                }
                self?.weatherPresenter?.sendToDataPresenter(weatherInfo: weathers)
            } catch {
                print("JSON Error: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func sevenDayWeather(cityName: String) {
        let url: URL = URL(string: "\(URLs.https)\(URLs.domain)\(Paths.weatherForecase)?city=\(cityName)&key=\(Constants.weatherKey)") ?? URL(fileURLWithPath: "")
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if error != nil || data == nil {
                print("Error \(String(describing: error?.localizedDescription))")
                return
            }
            do {
                let responseData = try JSONDecoder().decode(WeatherForecastResponse.self, from: data ?? Data())
                var weathers = [WeatherForecast]()
                if let responseList = responseData.data {
                    weathers = responseList
                }
                self?.weatherPresenter?.sendToDataPresenter(weatherInfo: weathers)
            } catch {
                print("JSON Error: \(error.localizedDescription)")
            }
        }.resume()
    }
}
