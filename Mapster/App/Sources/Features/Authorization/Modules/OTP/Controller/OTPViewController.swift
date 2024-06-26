//
//  OTPViewController.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 22.02.2024.
//

import SnapKit
import UIKit

protocol OTPNavigationDelegate: AnyObject {
    func didConfirmForLogin(_ viewController: OTPViewController)
    func didConfirmForPasswordReset(_ viewController: OTPViewController)
}

final class OTPViewController: UIViewController {
    enum ViewSate {
        case registration
        case passwordReset
    }
    
    weak var navigationDelegate: OTPNavigationDelegate?
    private var viewState: ViewSate = .registration
    private var timer: Timer?
    private var countdown: Int = 61
    
    private var textFields: [OTPTextField] = []
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.mulish(name: .extraBold, size: 24)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Для успешного подтверждения, введите  последние 4 цифры номера, с которого поступил звонок."
        label.font = Font.mulish(name: .light, size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var codeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 14
        stackView.contentMode = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var actionButton: ActionButton = {
        let button = ActionButton()
        button.addTarget(self, action: #selector(actionButtonDidTap), for: .touchUpInside)
        button.setTitle("Подтвердить", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [codeLabel, againLabel])
        stackView.spacing = 4
        return stackView
    }()
    
    private let codeLabel: UILabel = {
        let label = UILabel()
        label.text = "Не получили код?"
        label.font = Font.mulish(name: .bold, size: 13)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var againLabel: UILabel = {
        let label = UILabel()
        label.text = "Получить звонок еще раз"
        label.font = Font.mulish(name: .bold, size: 13)
        label.textAlignment = .center
        label.textColor = .textHighlight
        label.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(againDidTap))
        label.addGestureRecognizer(gesture)
        label.isHidden = true
        return label
    }()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "Запросите новый код через 01:00"
        label.font = Font.mulish(name: .regular, size: 13)
        label.textAlignment = .center
        label.textColor = .black.withAlphaComponent(0.5)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupTextFields()
        startTimer()
    }
    
    init(viewState: ViewSate) {
        self.viewState = viewState
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func actionButtonDidTap() {
        switch viewState {
        case .registration:
            navigationDelegate?.didConfirmForLogin(self)
        case .passwordReset:
            navigationDelegate?.didConfirmForPasswordReset(self)
        }
    }
    
    @objc
    private func againDidTap() {
        guard timer == nil else { return }
        startTimer()
    }
    
    @objc
    private func updateTimer() {
        timerLabel.isHidden = countdown == 0
        againLabel.isHidden = countdown > 0
        if countdown > 0 {
            countdown -= 1
            timerLabel.text = "Запросите новый код через \(formatSeconds(seconds: countdown))"
        } else {
            timer?.invalidate()
            timer = nil
        }
    }
    
    private func formatSeconds(seconds: Int) -> String {
        let minutes = seconds / 61
        let remainingSeconds = seconds % 60
        let formattedTime = String(format: "%d:%02d", minutes, remainingSeconds)
        return formattedTime
    }
    
    private func setupTextFields() {
        codeStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for index in 0..<4 {
            let textField = OTPTextField()
            textField.delegate = self
            textFields.append(textField)
            index != 0 ? (textField.previousTextField = textFields[index-1]) : (textField.previousTextField = nil)
            index != 0 ? (textFields[index - 1].nextTextField = textField) : ()
            
            codeStackView.addArrangedSubview(textField)
        }
        textFields[0].becomeFirstResponder()
    }
    
    private func startTimer() {
        countdown = 60
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    private func setupViews() {
        switch viewState {
        case .registration:
            titleLabel.text = "Последний шаг"
        case .passwordReset:
            titleLabel.text = "Сбросить пароль"
        }
        [titleLabel, descriptionLabel, codeStackView, actionButton, textStackView, timerLabel].forEach {
            view.addSubview($0)
        }
        view.backgroundColor = .white
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        codeStackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(36)
            $0.centerX.equalToSuperview()
        }
        actionButton.snp.makeConstraints {
            $0.top.equalTo(codeStackView.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(50)
        }
        textStackView.snp.makeConstraints {
            $0.top.equalTo(actionButton.snp.bottom).offset(64)
            $0.centerX.equalToSuperview()
        }
        timerLabel.snp.makeConstraints {
            $0.top.equalTo(textStackView.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }
}

// MARK: - UITextFieldDelegate

extension OTPViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkForValidity()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange,
                   replacementString string: String) -> Bool {
        guard let textField = textField as? OTPTextField else { return true }
        if string.count > 1 {
            textField.resignFirstResponder()
            autoFillTextField(with: string)
            return false
        } else {
            if (range.length == 0 && string == "") {
                return false
            } else if (range.length == 0){
                if textField.nextTextField == nil {
                    textField.text? = string
                    textField.resignFirstResponder()
                } else {
                    textField.text? = string
                    textField.nextTextField?.becomeFirstResponder()
                }
                return false
            }
            return true
        }
    }
    
    private func checkForValidity() {
        for fields in textFields {
            if (fields.text?.trimmingCharacters(in: CharacterSet.whitespaces) == "") {
                actionButton.isEnabled = false
                return
            }
        }
        resignFirstResponder()
        actionButton.isEnabled = true
    }
    
    private final func autoFillTextField(with string: String) {
        var remainingStringStack = string.reversed().compactMap{String($0)}
        for textField in textFields {
            if let charToAdd = remainingStringStack.popLast() {
                textField.text = String(charToAdd)
            } else {
                break
            }
        }
        checkForValidity()
    }
}
