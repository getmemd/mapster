//
//  Collection+Safe.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 27.03.2024.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
