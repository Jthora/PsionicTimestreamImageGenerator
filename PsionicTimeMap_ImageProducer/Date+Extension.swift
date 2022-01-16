//
//  Date+Extension.swift
//  PsionicTimeMap_ImageProducer
//
//  Created by Jordan Trana on 10/9/20.
//  Copyright © 2020 Jordan Trana. All rights reserved.
//

import Foundation

extension Date {
    
    init?(year: Int, month: Int, day: Int, timeZone:TimeZone, hour:Int, minute:Int) {
        
        // Specify date components
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.timeZone = timeZone
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        // Create date from components
        let userCalendar = Calendar.current // user calendar
        guard let date = userCalendar.date(from: dateComponents) else { return nil }
        self = date
    }
    
    var filenameString: String {
        return DateFormatter.filenameDateFormat.string(from: self)
    }
}

extension TimeInterval {
    
    func toYears() -> Double {
        return self / 3.154e+7
    }
    
}


extension DateFormatter {
    
    static let filenameDateFormat: DateFormatter = { return DateFormatter.with(dateFormat:"yyyyMMdd") }()
    
    static func with(dateFormat : String) -> DateFormatter {
        let df = DateFormatter()
        df.dateFormat = dateFormat
        return df
    }
    
    static let shortDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .none
        
        return df
    }()
    
    static let mediumDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        
        return df
    }()

    static let mediumTimeFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .none
        df.timeStyle = .medium
        
        return df
    }()
    
    static let mediumDateTimeFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .medium

        return df
    }()
}
