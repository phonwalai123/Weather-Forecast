//
//  ForecastWeatherViewController.swift
//  Weather Forecast
//
//  Created by phonwalai on 26/8/2565 BE.
//

import Foundation
import UIKit

class ForecastWeatherViewController: UIViewController,UITableViewDelegate,UITableViewDataSource  {
    
    @IBOutlet var table: UITableView!
    let networkManager = WeatherNetworkManager()
    var forecastData: [ForecastTemperature] = []
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        forecastData = []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        self.title = "Forecast"
        let city = UserDefaults.standard.string(forKey: "SelectedCity") ?? ""
        networkManager.fetchNextFiveWeatherForecast(city: city) { (forecast) in
            self.forecastData = forecast
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
        
        table.register(ForecastWeatherViewCell.nib(), forCellReuseIdentifier: ForecastWeatherViewCell.identifier)
        table.delegate = self
        table.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: ForecastWeatherViewCell.identifier, for: indexPath) as! ForecastWeatherViewCell
        cell.configure(with: forecastData[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
