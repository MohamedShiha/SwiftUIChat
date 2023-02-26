//
//  Date+Extensions.swift
//  SwiftUIChat
//
//  Created by Mohamed Shiha on 2/22/23.
//

import Foundation

extension Date {
	
	/// Returns time in date like 9:21 PM
	func timeFormatted() -> String {
		return self.formatted(format: "h:mm a")
	}
	
	func formatted(format: String) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = format
		formatter.amSymbol = "AM"
		formatter.pmSymbol = "PM"
		return formatter.string(from: self)
	}
}
