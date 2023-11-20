//
//  WeatherViewController.swift
//  weather_with_animation
//
//  Created by Tien Thanh on 11/17/23.
//

import UIKit
import Lottie
import ViewAnimator

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var location: LottieAnimationView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherTempLabel: UILabel!
    @IBOutlet weak var weatherIconImage: UIImageView!
    @IBOutlet weak var weatherDescLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cloudLabel: UILabel!
    @IBOutlet weak var windyLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var shadowThreeView: UIView!
    @IBOutlet weak var shadowTwoView: UIView!
    @IBOutlet weak var shadowOneView: UIView!
    @IBOutlet weak var dailyWeatherView: UIView!
    
    @IBOutlet weak var searchButton: UIButton!
    var weatherList = [Weather]()
    var weatherTime: String = ""
    var weatherForecast = [WeatherForecast]()
    var cities = [String]()
    var cellIdentifier = "WeatherCollectionViewCell"
    
    var weatherPresenterObject : ViewToWeatherPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Deafult Tokyo
        weatherPresenterObject?.getCurrentWeather(cityName : "Tokyo")
        weatherPresenterObject?.sevenDayWeather(cityName: "Tokyo")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Animations
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.shadowThreeView.transform = CGAffineTransform(translationX: 0, y: -30)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.8, animations:  {
            self.shadowTwoView.transform = CGAffineTransform(translationX: 0, y: -30)
        }, completion: nil)
        
        UIView.animate(withDuration: 1.3, animations:  {
            self.shadowOneView.transform = CGAffineTransform(translationX: 0, y: -30)
        }, completion: nil)
        
        UIView.animate(withDuration: 1.8, animations:  {
            self.dailyWeatherView.transform = CGAffineTransform(translationX: 0, y: -30)
        }, completion: nil)
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        var city = ""
        let cities = cities.map {
            $0.lowercased()
        }
        
        if searchTextField.text == "" || cities.contains(searchTextField.text?.lowercased() ?? "") == false {
            searchTextField.text = ""
            return
        } else {
            if let searchText = searchTextField.text {
                city = convertEnglishCharacter(text: searchText)
            }
            location.play()
            weatherPresenterObject?.getCurrentWeather(cityName: city)
            weatherPresenterObject?.sevenDayWeather(cityName: city)
        }
        
        searchTextField.endEditing(true)
    }
    
    private func setupUI() {
        searchTextField.delegate = self
        collectionView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(UINib(nibName: cellIdentifier,
                              bundle: nil),
                        forCellWithReuseIdentifier: cellIdentifier)
        }
        
        WeatherRouter.createWeather(ref: self)
        location.play()
        
        dailyWeatherView.do {
            $0.layer.masksToBounds = false
            $0.layer.cornerRadius = 50
            $0.clipsToBounds = true
        }
        
        shadowOneView.do {
            $0.layer.masksToBounds = false
            $0.layer.cornerRadius = 45
            $0.clipsToBounds = true
        }
        
        shadowTwoView.do {
            $0.layer.masksToBounds = false
            $0.layer.cornerRadius = 40
            $0.clipsToBounds = true
        }
        
        shadowThreeView.do {
            $0.layer.masksToBounds = false
            $0.layer.cornerRadius = 35
            $0.clipsToBounds = true
        }
        
        // search textfield UI
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0,
                                  y: searchTextField.frame.height - 1,
                                  width: searchTextField.frame.width,
                                  height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        searchTextField.borderStyle = UITextField.BorderStyle.none
        searchTextField.layer.addSublayer(bottomLine)
        searchTextField.attributedPlaceholder = NSAttributedString(string: "City Name",
                                                                   attributes: [
                                                                    NSAttributedString.Key.foregroundColor: UIColor.systemGray3
                                                                   ])
        parseCSV()
    }
    
    
    
}

extension WeatherViewController {
    private func collectionviewAnimation() {
        // CollectionView animation
        let animation = AnimationType.zoom(scale: 0.5)
        UIView.animate(views : collectionView.visibleCells, animations: [animation])
    }
    
    private func convertEnglishCharacter(text: String) -> String {
        // convert English for url
        // Example: city name = New York City -> new_york_city
        let nonSpace = text.replacingOccurrences(of: " ", with: "_")
        let onlyEnglishString = nonSpace.folding(options: .diacriticInsensitive, locale: nil)
        
        return onlyEnglishString.lowercased()
    }
    
    // cities's names in csv file so searching in csv file
    func openCSV(fileName:String, fileType: String)-> String? {
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType) else { return nil }
        do {
            let contents = try String(contentsOfFile: filepath, encoding: .utf8)
            return contents
        } catch {
            print("File read Error for file \(filepath)")
            return nil
        }
    }
    
    private func parseCSV() {
        let dataString: String! = openCSV(fileName: "cities_full", fileType: "csv")
        var items: [(String, String, String)] = []
        let lines: [String] = dataString.components(separatedBy: NSCharacterSet.newlines) as [String]
        
        for line in lines {
            var values: [String] = []
            if line != "" {
                if line.range(of: "\"") != nil {
                    var textToScan:String = line
                    var value:String?
                    var textScanner:Scanner = Scanner(string: textToScan)
                    while !textScanner.isAtEnd {
                        if (textScanner.string as NSString).substring(to: 1) == "\"" {
                            textScanner.currentIndex = textScanner.string.index(after: textScanner.currentIndex)
                            
                            value = textScanner.scanUpToString("\"")
                            textScanner.currentIndex = textScanner.string.index(after: textScanner.currentIndex)
                        } else {
                            value = textScanner.scanUpToString(",")
                        }
                        
                        values.append(value ?? ""  as String)
                        
                        if !textScanner.isAtEnd{
                            let indexPlusOne = textScanner.string.index(after: textScanner.currentIndex)
                            
                            textToScan = String(textScanner.string[indexPlusOne...])
                        } else {
                            textToScan = ""
                        }
                        textScanner = Scanner(string: textToScan)
                    }
                } else  {
                    values = line.components(separatedBy: ",")
                }
                let item = (values[0], values[1], values[2])
                items.append(item)
                
                cities.append(item.1)
            }
        }
    }
}

extension WeatherViewController: PresenterToWeatherProtocol {
    func sendToDataView(weatherInfo: [Weather]) {
        if (weatherInfo.count > 0) {
            weatherList = weatherInfo
            let date = Date()
            let dateFormatter = DateFormatter()
            
            DispatchQueue.main.async { [weak self] in
                let firstWeatherInfo = self?.weatherList[0]
                let timezone = firstWeatherInfo?.timezone ?? ""
                dateFormatter.timeZone = TimeZone(identifier: timezone)
                dateFormatter.dateFormat = "MMM d, EEE, hh:mm a"
                dateFormatter.locale = Locale(identifier: "en")
                self?.weatherTime = dateFormatter.string(from: date)
                dateFormatter.dateFormat = "HH"
                let stringHour = dateFormatter.string(from: date)
                let hour = Int(stringHour) ?? Int()
                
                switch hour {
                case 5...18:
                    self?.backgroundImage.image = UIImage(named:"Daytime")
                case 18...24:
                    self?.backgroundImage.image = UIImage(named: "NightDay")
                default:
                    self?.backgroundImage.image = UIImage(named:"NightDay")
                }
                
                self?.cityNameLabel.text = firstWeatherInfo?.city_name ?? ""
                self?.weatherTempLabel.text = "\(firstWeatherInfo?.temp ?? 0.0)°"
                self?.weatherDescLabel.text = firstWeatherInfo?.weather?.description ?? ""
                self?.sunsetLabel.text = firstWeatherInfo?.sunrise ?? ""
                self?.windyLabel.text = String(format: "%0.2f", firstWeatherInfo?.wind_spd ?? 0.0) + "m/s"
                self?.cloudLabel.text = "\(firstWeatherInfo?.clouds ?? 0) %"
                self?.dateLabel.text = self?.weatherTime
                self?.weatherIconImage.image = UIImage(systemName: (firstWeatherInfo?.weather?.getIcon()) ?? "")
            }
        }
    }
    
    func sendToDataView(weatherInfo: [WeatherForecast]) {
        if weatherInfo.count > 0 {
            weatherForecast = weatherInfo
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.33, execute: { [weak self] in
                self?.collectionView.reloadData()
                self?.collectionView.performBatchUpdates({
                    self?.collectionviewAnimation()
                })
            })
        }
    }
}

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text?.isEmpty == true {
            searchTextField.placeholder = "Enter the city name"
            return false
        } else {
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchTextField.text = ""
    }
}

extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width/3 - 16
        return CGSize(width: width, height: width*1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalContentWidth: Double = Double(collectionView.frame.size.width/3.0 - 16.0) * Double(Constants.numberOfItemsInSection)
        let totalCellSpacing: Double = Constants.cellSpacing * Double(Constants.numberOfItemsInSection - 1)
        
        let leftInset = (collectionView.frame.width - CGFloat(totalContentWidth + totalCellSpacing))/2
        
        return UIEdgeInsets(top: 0.0, left: leftInset, bottom: 0.0, right: leftInset)
    }
}

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherForecast.count > 0 ? Constants.numberOfItemsInSection : 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellIdentifier,
            for: indexPath) as? WeatherCollectionViewCell
        cell?.configUI(with: weatherForecast[indexPath.row + 1])
        return cell ?? UICollectionViewCell()
    }
}
