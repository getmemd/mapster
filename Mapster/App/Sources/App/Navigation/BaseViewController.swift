//
//  BaseViewController.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 07.03.2024.
//

import UIKit

class BaseViewController: UIViewController {
    func showAlert(title: String? = nil, message: String?) {
        let alert = UIAlertController(title: title ?? "Ошибка",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
