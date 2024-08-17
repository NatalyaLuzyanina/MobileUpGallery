//
//  Date+extension.swift
//  MobileUpGallery
//
//  Created by Natalia on 17.08.2024.
//

import Foundation

extension Date {
    /// приводит тип к виду "17 августа 2024"
    func formatToTextString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMMM yyyy"
        
        return dateFormatter.string(from: self)
    }
}
