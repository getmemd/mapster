//
//  BaseViewController.swift
//  Mapster
//
//  Created by User on 07.03.2024.
//

import UIKit

class BaseViewController: UIViewController {
    // Лоадер
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // Показ уведомление об ошибке
    func showErrorAlert(message: String?) {
        let alert = UIAlertController(title: "Ошибка",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func setupViews() {
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
