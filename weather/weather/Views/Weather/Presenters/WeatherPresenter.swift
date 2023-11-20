//
//  WeatherPresenter.swift
//  weather_with_animation
//
//  Created by Tien Thanh on 11/17/23.
//

import Foundation

class WeatherPresenter: ViewToWeatherPresenterProtocol {
    var weatherInteractor: PresenterToInteractorWeatherProtocol?
    var weatherView: PresenterToWeatherProtocol?
    
    func getCurrentWeather(cityName: String) {
        weatherInteractor?.getCurrentWeather(cityName: cityName)
    }
    
    func sevenDayWeather(cityName: String) {
        weatherInteractor?.sevenDayWeather(cityName: cityName)
    }
}

extension WeatherPresenter: InteractorToPresenterWeatherProtocol {
    func sendToDataPresenter(weatherInfo: [Weather]) {
        weatherView?.sendToDataView(weatherInfo: weatherInfo)
    }
    
    func sendToDataPresenter(weatherInfo: [WeatherForecast]) {
        weatherView?.sendToDataView(weatherInfo: weatherInfo)
    }
    
    
}
