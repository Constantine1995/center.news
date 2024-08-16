//
//  String+Extension.swift
//  News
//
//  Created by Constantine Likhachov on 14.08.2024.
//

import Foundation

extension String {
    
    func formattedDate() -> String {
         let isoFormatter = ISO8601DateFormatter()
         if let date = isoFormatter.date(from: self) {
            let relativeDateFormatter = RelativeDateTimeFormatter()
             return relativeDateFormatter.localizedString(for: date, relativeTo: Date())
         } else {
             return "Invalid date"
         }
     }
}
