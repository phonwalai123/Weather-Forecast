//
//  ForecastWeatherModel.swift
//  Weather Forecast
//
//  Created by phonwalai on 26/8/2565 BE.
//

import UIKit

struct WeatherInfo {
    let temp: Float
    let min_temp: Float
    let max_temp: Float
    let description: String
    let icon: String
    let time: String
}

struct ForecastTemperature {
    let weekDay: String?
    let hourlyForecast: [WeatherInfo]?
}
