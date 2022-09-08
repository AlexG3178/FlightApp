//
//  DateExt.swift
//  KiwiFlights
//
//  Created by Alexandr Grigoriev on 24.08.2022.
//

import UIKit

extension Date {
    
    func getTodayDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: self)
    }
    
    func getTomorrowDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: self) ?? self)
    }
}
