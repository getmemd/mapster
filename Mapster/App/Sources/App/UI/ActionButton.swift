import SnapKit
import UIKit

final class ActionButton: UIButton {
    public override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? .accent : .darkGray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        layer.cornerRadius = 10
        backgroundColor = .accent
        setTitleColor(.white, for: .normal)
        titleLabel?.font = Font.mulish(name: .semiBold, size: 20)
    }
}
