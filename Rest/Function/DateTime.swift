//
//  DateTime.swift
//  Rest
//
//  Created by Me Tomm on 7/5/2568 BE.
//

import Foundation

public func convertDateTime(date: String, time: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy HH:mm" //

    let combined = "\(date) \(time)"
    return formatter.date(from: combined) ?? Date.distantPast
}

public func getDateNow() -> String{
    let now = Date()
    let calendar = Calendar.current
    let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "th_TH")
    let dateString = formatter.string(from: now)
    return dateString
}

public func getDateFuture(month: Int) -> String{
    let now = Date()
    let calendar = Calendar.current
    let futureDate = calendar.date(byAdding: .month, value: month, to: now)!
    let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "th_TH")
    let dateStringFuture = formatter.string(from: futureDate)
    return dateStringFuture
}

public func getDateFutureDay(day: Int) -> String{
    let now = Date()
    let calendar = Calendar.current
    let futureDate = calendar.date(byAdding: .day, value: day, to: now)!
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy"
    formatter.locale = Locale(identifier: "th_TH")
    let dateStringFuture = formatter.string(from: futureDate)
    return dateStringFuture
}

public func getTimeNow() -> String {
    let now = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm" 
    formatter.locale = Locale(identifier: "th_TH")
    let timeString = formatter.string(from: now)
    return timeString
}

