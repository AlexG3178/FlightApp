//
//  Helper.swift
//  KiwiFlights
//
//  Created by Alexandr Grigoriev on 03.09.2022.
//

import Foundation

class Helper {
    
    static func formatIsoDate(_ dateString: String) -> String {
        
        
//                let dateString = "2022-09-03T18:00:00.000Z"
        
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZ"
                let date = dateFormatter.date(from: dateString) ?? Date()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let resultString = dateFormatter.string(from: date)
        
        
        
//        guard let ind = dateString.firstIndex(of: "T") else {
//            return ""
//        }
//        let shortDateStr = dateString.prefix(upTo: ind)
//        let dateComponents = shortDateStr.components(separatedBy: "-").reversed()
//        var resultString = ""
//        for dateComponent in dateComponents {
//            if resultString.isEmpty {
//                resultString += dateComponent
//            } else {
//                resultString += "/\(dateComponent)"
//            }
//        }
        
        
        
        return resultString
    }
}
