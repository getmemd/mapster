import Foundation

// Расширение для коллекций, добавляющее безопасный доступ по индексу
extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
