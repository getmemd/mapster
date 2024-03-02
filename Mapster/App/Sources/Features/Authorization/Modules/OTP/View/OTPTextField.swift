//
//  OTPTextField.swift
//  Mapster
//
//  Created by User on 23.02.2024.
//

import SnapKit
import UIKit

final class OTPTextField: UITextField {
    // Пердыдущий символ
    weak var previousTextField: OTPTextField?
    // Следующий символ
    weak var nextTextField: OTPTextField?
    
    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Метод удаления который будет переносить на предыдущий символ
    override public func deleteBackward(){
        text = ""
        previousTextField?.becomeFirstResponder()
    }
    
    // Настройка представлений
    private func setupViews() {
        textAlignment = .center
        backgroundColor = .lightGray.withAlphaComponent(0.2)
        font = Font.mulish(name: .regular, size: 14)
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        borderStyle = UITextField.BorderStyle.none
        layer.cornerRadius = 5
    }
    
    private func setupConstraints() {
        snp.makeConstraints {
            $0.size.equalTo(36)
        }
    }
}
