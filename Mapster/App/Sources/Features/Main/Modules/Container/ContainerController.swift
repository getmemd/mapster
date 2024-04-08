//
//  ContainerController.swift
//  Mapster
//
//  Created by User on 26.02.2024.
//

import UIKit

final class ContainerController: UITabBarController {
    // Контейнер для таббара
    init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .accent
    }
}
