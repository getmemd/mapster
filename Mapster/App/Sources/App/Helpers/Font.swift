//
//  Font.swift
//  Mapster
//
//  Created by User on 17.02.2024.
//

import UIKit

enum Font {
    enum Mulish: String {
        case extraBold = "Mulish-ExtraBold"
        case bold = "Mulish-Bold"
        case semiBold = "Mulish-SemiBold"
        case regular = "Mulish-Regular"
        case light = "Mulish-Light"
    }
    
    static func customFont(name: String, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name, size: size) else {
            fatalError("Font '\(name)' not found")
        }
        return font
    }
    
    static func mulish(name: Mulish, size: CGFloat) -> UIFont {
        customFont(name: name.rawValue, size: size)
    }
}
