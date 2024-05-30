import Foundation

// Расширение для Double, добавляющее метод форматирования в валюту
extension Double {
    // Метод для форматирования числа в валюту
    func formatAsCurrency() -> String {
        // Настройка форматтера чисел
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.locale = Locale(identifier: "kk_KZ")
        // Форматирование числа и добавление валютного символа
        if let formattedNumber = formatter.string(from: NSNumber(value: self)) {
            return "\(formattedNumber) ₸"
        }
        // Возврат сообщения об ошибке, если форматирование не удалось
        return "Invalid Number"
    }
}
