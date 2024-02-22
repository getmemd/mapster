//
//  OTPTextField.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 23.02.2024.
//

import SnapKit
import UIKit

final class OTPTextField: UITextField {
    weak var previousTextField: OTPTextField?
    weak var nextTextField: OTPTextField?
    
    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func deleteBackward(){
        text = ""
        previousTextField?.becomeFirstResponder()
    }
    
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
