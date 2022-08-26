//
//  WeatherServiceProtocol.swift
//  Weather Forecast
//
//  Created by phonwalai on 26/8/2565 BE.
//

import UIKit

protocol WeatherServiceProtocol {
    func fetchCurrentWeather(city: String, completion: @escaping (WeatherModel) -> ())
    func fetchCurrentLocationWeather(lat: String, lon: String, completion: @escaping (WeatherModel) -> ())
    func fetchNextFiveWeatherForecast(city: String, completion: @escaping ([ForecastTemperature]) -> ())
}

