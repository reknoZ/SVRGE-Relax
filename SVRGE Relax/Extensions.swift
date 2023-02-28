//
//  Extensions.swift
//  Load URLs from list in Firebase
//
//  Created by Zicount on 21.02.23.
//

import Foundation

extension Date {
	init(from dateString: String, formattedAs format: String = "yyyyMMddThhmmss") {
		let formatter = DateFormatter()
		formatter.dateFormat = format
		formatter.locale = Locale.autoupdatingCurrent
		self = formatter.date(from: dateString)! // this is assumes perfect data from SwissVolley IT 2.0
	}
	
	func toString(withFormat format: String = "dd.MM.yyyy") -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format
		let string = dateFormatter.string(from: self)
		
		return string
	}
	
	func isToday() -> Bool {
		return Calendar.current.isDateInToday(self)
	}
	
	func isTomorrow() -> Bool {
		return Calendar.current.isDateInTomorrow(self)
	}
	
	func isInFuture() -> Bool {
		let twoDaysHence = Calendar.current.date(byAdding: .day, value: 2, to: Date().midnight())!
		
		return Calendar.current.compare(self, to: twoDaysHence, toGranularity: .day) == .orderedDescending
	}
	
	func isInPast() -> Bool {
		return Calendar.current.compare(self, to: Date().midnight(), toGranularity: .day) == .orderedAscending
	}

	//	let sortingHat = Calendar.current.compare(match.date, to: Date(), toGranularity: .day)
	
	func midnight() -> Date {
		let year = Calendar.current.component(.year, from: self)
		let month = Calendar.current.component(.month, from: self)
		let day = Calendar.current.component(.day, from: self)
		return dateFromComponents(year: year, month: month, day: day)!
	}
}

func dateFromComponents(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0) -> Date? {
	var dateComponents = DateComponents()
	dateComponents.year = year
	dateComponents.month = month
	dateComponents.day = day
	//TODO: Make sure this is time-zone aware
	dateComponents.timeZone = TimeZone(abbreviation: "CEST")
	dateComponents.hour = hour
	dateComponents.minute = minute
	
	// Create date from components
	let userCalendar = Calendar.current // user calendar
	return userCalendar.date(from: dateComponents)
}

extension String {
	func toDate(withFormat format: String = "dd.MM.yyyy HH:mm") -> Date?{
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format
		dateFormatter.locale = Locale.init(identifier: "ch_FR")
		let date = dateFormatter.date(from: self)
		
		return date
	}
}
