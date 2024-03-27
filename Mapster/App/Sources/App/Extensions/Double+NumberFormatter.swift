//
//  Double+NumberFormatter.swift
//  Mapster
//
//  Created by User on 27.03.2024.
//

import Foundation

extension Double {
    func formatAsCurrency() -> String {
        // Форматирование числа Double в String со знаком валюты
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
