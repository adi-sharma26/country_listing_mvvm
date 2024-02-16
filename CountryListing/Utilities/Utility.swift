//
//  Utility.swift
//  CountryListing
//
//  Created by Aditya Sharma on 16/02/24.
//

import Foundation

final class Utility {
    
    private class func dayWithOrdinalSuffix(day: Int) -> String {
        switch day {
        case 1, 21, 31:
            return "st"
        case 2, 22:
            return "nd"
        case 3, 23:
            return "rd"
        default:
            return "th"
        }
    }
    
    class func formattedCurrentDate() -> String {
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "PST")
        
        let dayOfMonth = Calendar.current.component(.day, from: currentDate)
        
        let formattedDay = dayWithOrdinalSuffix(day: dayOfMonth)
        
        let customDateFormat = "d'\(formattedDay)' MMM h:mm a"
        
        dateFormatter.dateFormat = customDateFormat
        
        let formattedDate = dateFormatter.string(from: currentDate)
        
        return formattedDate
    }
}
