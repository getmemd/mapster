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
