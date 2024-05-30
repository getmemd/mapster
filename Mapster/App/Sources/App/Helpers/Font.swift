import UIKit

// Перечисление для шрифтов
enum Font {
    // Вложенное перечисление для шрифтов Mulish
    enum Mulish: String {
        case extraBold = "Mulish-ExtraBold"
        case bold = "Mulish-Bold"
        case semiBold = "Mulish-SemiBold"
        case regular = "Mulish-Regular"
        case light = "Mulish-Light"
    }
    
    // Метод для создания пользовательского шрифта
    static func customFont(name: String, size: CGFloat) -> UIFont {
        // Проверка наличия шрифта
        guard let font = UIFont(name: name, size: size) else {
            fatalError("Font '\(name)' not found")
        }
        return font
    }
    
    // Метод для создания шрифта Mulish
    static func mulish(name: Mulish, size: CGFloat) -> UIFont {
        customFont(name: name.rawValue, size: size)
    }
}
