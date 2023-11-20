//
//  ViewController.swift
//  weather_with_animation
//
//  Created by Tien Thanh on 11/16/23.
//

import UIKit
import Lottie

class ViewController: UIViewController {
    @IBOutlet weak var launchAnimated: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        launchAnimate()
    }
    
    private func launchAnimate() {
        launchAnimated.play{ (finished) in
            let weatherViewController = WeatherViewController()
            weatherViewController.modalPresentationStyle = .fullScreen
            self.present(weatherViewController, animated: true)
        }
    }
}

