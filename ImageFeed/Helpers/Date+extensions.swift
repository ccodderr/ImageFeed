//
//  Date+extensions.swift
//  ImageFeed
//
//  Created by Yana Silosieva on 14.11.2024.
//

import Foundation

private extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
}

extension Date {
    var dateTimeString: String {
        DateFormatter.dateFormatter.string(from: self)
    }
}
