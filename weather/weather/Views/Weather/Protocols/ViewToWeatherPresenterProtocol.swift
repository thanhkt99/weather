//
//  ViewToWeatherPresenterProtocol.swift
//  weather_with_animation
//
//  Created by Tien Thanh on 11/17/23.
//

import Foundation

protocol ViewToWeatherPresenterProtocol {
    var weatherInteractor: PresenterToInteractorWeatherProtocol? { get set }
    var weatherView: PresenterToWeatherProtocol? { get set }
    func getCurrentWeather(cityName: String)
    func sevenDayWeather(cityName: String)
}

protocol PresenterToInteractorWeatherProtocol {
    var weatherPresenter: InteractorToPresenterWeatherProtocol? { get set }
    func getCurrentWeather(cityName: String)
    func sevenDayWeather(cityName: String)
}

protocol InteractorToPresenterWeatherProtocol {
    func sendToDataPresenter(weatherInfo: [Weather])
    func sendToDataPresenter(weatherInfo: [WeatherForecast])
}

protocol PresenterToWeatherProtocol {
    func sendToDataView(weatherInfo: [Weather])
    func sendToDataView(weatherInfo: [WeatherForecast])
}

protocol PresenterToRouterWeatherProtocol {
    static func createWeather(ref: WeatherViewController)
}
