import Foundation

extension Collection {
    // Безопасно брать элементы из массивов
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
