//
//  WeatherForecast.swift
//  weather_with_animation
//
//  Created by Tien Thanh on 11/16/23.
//

import Foundation
class WeatherForecast : Codable
{
    var temp : Double?
    var datetime : String?
    var weather : WeatherDetail?
    
    private init(){}
}
