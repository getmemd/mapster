//
//  CircularView.swift
//  Mapster
//
//  Created by User on 05.04.2024.
//

import UIKit

final class CircularView: UIView {
    // Полукруглый фон
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius = bounds.width * 2
        let center = CGPoint(x: bounds.midX, y: bounds.height - radius)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: bounds.width, y: 0))
        path.addArc(withCenter: center, radius: radius, startAngle: CGFloat.pi, endAngle: 0, clockwise: false)
        path.close()
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}
