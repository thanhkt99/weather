//
//  Weather.swift
//  weather_with_animation
//
//  Created by Tien Thanh on 11/16/23.
//

import Foundation

class Weather : Codable
{
    var temp : Double?
    var city_name : String?
    var wind_spd : Double?
    var wind_cdir_full : String?
    var wind_cdir : String?
    var sunrise : String?
    var timezone : String?
    var clouds : Int?
    var weather : WeatherDetail?
    
    private init(){}
    
}
