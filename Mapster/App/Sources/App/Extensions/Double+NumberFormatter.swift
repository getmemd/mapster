//
//  Double+NumberFormatter.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 27.03.2024.
//

import Foundation

extension Double {
    func formatAsCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.locale = Locale(identifier: "kk_KZ")
        if let formattedNumber = formatter.string(from: NSNumber(value: self)) {
            return "\(formattedNumber) ₸"
        }
        return "Invalid Number"
    }
}
