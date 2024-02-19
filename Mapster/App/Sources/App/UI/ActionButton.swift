//
//  ActionButton.swift
//  Mapster
//
//  Created by User on 19.02.2024.
//

import SnapKit
import UIKit

final class ActionButton: UIButton {
    // Переопределяем переменную isEnabled для изменения фона кнопки в зависимости от ее доступности
    public override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? UIColor(named: "AccentColor") : .darkGray
        }
    }
    
    // Инициализатор суперкласса с настройками UI
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI() // Вызываем метод для настройки внешнего вида кнопки
    }
    
    // Обязательный инициализатор, не используется
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Приватный метод для настройки внешнего вида кнопки
    private func setupUI() {
        layer.cornerRadius = 10 // Устанавливаем скругленные углы
        backgroundColor = UIColor(named: "AccentColor") // Устанавливаем фон кнопки
        setTitleColor(.white, for: .normal) // Устанавливаем цвет текста для состояния normal
        titleLabel?.font = Font.mulish(name: .semiBold, size: 20) // Устанавливаем шрифт и размер текста
    }
}
