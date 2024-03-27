//
//  Collection+Safe.swift
//  Mapster
//
//  Created by User on 27.03.2024.
//

import Foundation

extension Collection {
    // Безопасно брать элементы из массивов
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
