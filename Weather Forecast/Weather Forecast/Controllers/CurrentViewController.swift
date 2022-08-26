//
//  CurrentViewController.swift
//  Weather Forecast
//
//  Created by phonwalai on 26/8/2565 BE.
//

import UIKit
import CoreLocation

class CurrentViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var currentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var iconImag: UIImageView!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let networkManager = WeatherNetworkManager()
    var isCelius: Bool = false
    var locationManager = CLLocationManager()
    var currentLoc: CLLocation?
    var stackView : UIStackView!
    var latitude : CLLocationDegrees!
    var longitude: CLLocationDegrees!
    var weather: WeatherModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        setupRightBarButton(iconName: "c.square")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        manager.delegate = nil
        let location = locations[0].coordinate
        latitude = location.latitude
        longitude = location.longitude
        loadDataUsingCoordinates(lat: latitude.description, lon: longitude.description)
    }
    
    func loadData(city: String) {
        networkManager.fetchCurrentWeather(city: city) { (weather) in
             let formatter = DateFormatter()
             formatter.dateFormat = "dd MMM yyyy"
             let stringDate = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt)))
             self.weather = weather
             DispatchQueue.main.async {
                 self.nameLabel.text = "\(weather.name ?? "") , \(weather.sys.country ?? "")"
                 self.tempLabel.text = (String(weather.main.temp) + "°C")
                 self.feelsLikeLabel.text = weather.weather[0].description
                 self.minTempLabel.text = ("Min: " + String(weather.main.temp_min) + "°C" )
                 self.maxTempLabel.text = ("Max: " + String(weather.main.temp_max) + "°C" )
                 self.pressureLabel.text = ("Pressure: " + String(weather.main.pressure))
                 self.humidityLabel.text = ("Humidity: " + String(weather.main.humidity))
                 self.dateLabel.text = stringDate
                 self.iconImag.loadImageFromURL(url: "http://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")
                 UserDefaults.standard.set("\(weather.name ?? "")", forKey: "SelectedCity")
             }
         }
    }
    
    func loadDataUsingCoordinates(lat: String, lon: String) {
        networkManager.fetchCurrentLocationWeather(lat: lat, lon: lon) { (weather) in
             let formatter = DateFormatter()
             formatter.dateFormat = "dd MMM yyyy"
             let stringDate = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt)))
             self.weather = weather
             DispatchQueue.main.async {
                 self.nameLabel.text = "\(weather.name ?? "") , \(weather.sys.country ?? "")"
                 self.tempLabel.text = (String(weather.main.temp) + "°C")
                 self.minTempLabel.text = ("Min: " + String(weather.main.temp_min) + "°C" )
                 self.maxTempLabel.text = ("Max: " + String(weather.main.temp_max) + "°C" )
                 self.feelsLikeLabel.text = weather.weather[0].description
                 self.pressureLabel.text = ("Pressure: " + String(weather.main.pressure))
                 self.humidityLabel.text = ("Humidity: " + String(weather.main.humidity))
                 self.dateLabel.text = stringDate
                 self.iconImag.loadImageFromURL(url: "http://openweathermap.org/img/wn/\(weather.weather[0].icon)@2x.png")
                 UserDefaults.standard.set("\(weather.name ?? "")", forKey: "SelectedCity")
             }
        }
    }
    
    //MARK: - Handlers
    @objc func handleAddPlaceButton() {
        let alertController = UIAlertController(title: "Add City", message: "", preferredStyle: .alert)
         alertController.addTextField { (textField : UITextField!) -> Void in
             textField.placeholder = "City Name"
         }
         let saveAction = UIAlertAction(title: "Add", style: .default, handler: { alert -> Void in
             let firstTextField = alertController.textFields![0] as UITextField
             print("City Name: \(String(describing: firstTextField.text))")
            guard let cityname = firstTextField.text else { return }
            self.loadData(city: cityname)
         })
         let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action : UIAlertAction!) -> Void in
            print("Cancel")
         })
      
         alertController.addAction(saveAction)
         alertController.addAction(cancelAction)
         self.present(alertController, animated: true, completion: nil)
    }

    @objc func handleShowForecast() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ForecastWeatherViewController") as! ForecastWeatherViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc func tempconvert() {
        isCelius = !isCelius
        guard weather != nil else {return}
        if isCelius {
            isCelius = true
            self.tempLabel.text = "\(String(describing: weather!.main.temp.CeliusConverterToFahrenheit()))" + "°F"
            self.minTempLabel.text = "Min: " + "\(String(describing: weather!.main.temp_min.CeliusConverterToFahrenheit()))" + "°F"
            self.maxTempLabel.text = "Max: " + "\(String(describing: weather!.main.temp_max.CeliusConverterToFahrenheit()))" + "°F"
            setupRightBarButton(iconName: "f.square")
        } else {
            isCelius = false
            self.tempLabel.text = "\(String(describing: weather!.main.temp))" + "°C"
            self.minTempLabel.text = "Min: " + "\(String(describing: weather!.main.temp_min))" + "°C"
            self.maxTempLabel.text = "Max: " + "\(String(describing: weather!.main.temp_max))" + "°C"
            setupRightBarButton(iconName: "c.square")
          
        }
    }
    
    func setupRightBarButton(iconName:String){
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "magnifyingglass")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(handleAddPlaceButton)),
            UIBarButtonItem(image: UIImage(systemName: "calendar.badge.clock")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(handleShowForecast)),
            UIBarButtonItem(image: UIImage(systemName: iconName)?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(tempconvert))]
    }
}


