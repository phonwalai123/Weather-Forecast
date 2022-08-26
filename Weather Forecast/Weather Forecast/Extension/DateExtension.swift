//
//  DateExtension.swift
//  Weather Forecast
//
//  Created by phonwalai on 26/8/2565 BE.
//

import UIKit

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}
