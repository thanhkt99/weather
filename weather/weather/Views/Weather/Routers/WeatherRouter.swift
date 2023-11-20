//
//  WeatherRouter.swift
//  weather_with_animation
//
//  Created by Tien Thanh on 11/17/23.
//

import Foundation
import Then

class WeatherRouter: PresenterToRouterWeatherProtocol {
    static func createWeather(ref: WeatherViewController) {
        let presenter = WeatherPresenter()
        ref.do {
            $0.weatherPresenterObject = presenter
            $0.weatherPresenterObject?.weatherView = ref
            $0.weatherPresenterObject?.weatherInteractor = WeatherInteractor()
            $0.weatherPresenterObject?.weatherInteractor?.weatherPresenter = presenter
        }
    }
}
