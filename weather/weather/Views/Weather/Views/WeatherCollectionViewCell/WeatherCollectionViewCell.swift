//
//  WeatherCollectionViewCell.swift
//  weather_with_animation
//
//  Created by Tien Thanh on 11/17/23.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var weatherTemp: UILabel!
    @IBOutlet weak var weatherDay: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configUI(with weatherForecast: WeatherForecast) {
        weatherImage.image = UIImage(systemName: weatherForecast.weather?.getIcon() ?? "cloud")
        weatherTemp.text = "\(weatherForecast.temp ?? 0)°"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = weatherForecast.datetime ?? ""
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMM d"
            dateFormatter.locale = Locale(identifier: "en")
            weatherDay.text = dateFormatter.string(from: date)
        }
    }
}
