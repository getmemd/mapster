//
//  UITextField+ViewPadding.swift
//  Mapster
//
//  Created by User on 19.02.2024.
//

import UIKit

extension UITextField {
    // Метод для добавления иконки в UITextField с отступом
    func addPaddingAndIcon(_ image: UIImage?, padding: CGFloat,isLeftView: Bool) {
        guard let image else { return }
        let frame = CGRect(x: 0, y: 0, width: image.size.width + padding, height: image.size.height)
        let outerView = UIView(frame: frame)
        let iconView  = UIImageView(frame: frame)
        iconView.image = image
        iconView.contentMode = .center
        outerView.addSubview(iconView)
        if isLeftView {
            leftViewMode = .always
            leftView = outerView
        } else {
            rightViewMode = .always
            rightView = outerView
        }
    }
}
