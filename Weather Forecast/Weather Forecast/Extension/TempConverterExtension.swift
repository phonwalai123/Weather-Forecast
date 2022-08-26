//
//  TempConverterExtension.swift
//  Weather Forecast
//
//  Created by phonwalai on 26/8/2565 BE.
//

import UIKit

extension Float {
    func truncate(places : Int)-> Float {
        return Float(floor(pow(10.0, Float(places)) * self)/pow(10.0, Float(places)))
    }
    
    func kelvinToCeliusConverter() -> Float {
        let constantVal : Float = 273.15
        let kelValue = self
        let celValue = kelValue - constantVal
        return celValue.truncate(places: 1)
    }
    
    func CeliusConverterToFahrenheit() -> Float {
        let constantVal : Float = 9/5
        let celius = self
        let Fahrenheit = celius * constantVal + 32
        return Fahrenheit.truncate(places: 1)
    }
}
