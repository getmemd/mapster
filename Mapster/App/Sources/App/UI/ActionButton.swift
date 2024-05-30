import SnapKit
import UIKit

// Финальный класс для кнопки действия
final class ActionButton: UIButton {
    // Переопределение свойства isEnabled
    public override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? .accent : .darkGray
        }
    }
    
    // Инициализация кнопки
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    // Инициализация из storyboard или xib не поддерживается
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Настройка UI кнопки
    private func setupUI() {
        layer.cornerRadius = 10
        backgroundColor = .accent
        setTitleColor(.white, for: .normal)
        titleLabel?.font = Font.mulish(name: .semiBold, size: 20)
    }
}
