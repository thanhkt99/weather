//
//  Constants.swift
//  weather_with_animation
//
//  Created by Tien Thanh on 11/17/23.
//

import Foundation

class URLs {
    static let https = "https://"
    static let domain = "api.weatherbit.io/v2.0"
    
}

class Paths {
    static let weatherCurrent = "/current"
    static let weatherAlert = "/alerts"
    static let weatherForecase = "/forecast/daily"
}

class Constants {
    /// get API KEY in https://www.weatherbit.io/account/dashboard
    /// free account can get API Key free for current weather + alerts + 7 day forecasts
    /// total 50 calls free each day 
    static let weatherKey = "40d1aa44b45345f49c742f12cc5cf7f3"
    static let cellSpacing = 5.0
    /// set numberOfItemsInSection = 3 to view only 3 next days from today
    static let numberOfItemsInSection = 3
}
