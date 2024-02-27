//
//  ContainerController.swift
//  Mapster
//
//  Created by Adilkhan Medeuyev on 26.02.2024.
//

import UIKit

final class ContainerController: UITabBarController {
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
        tabBar.tintColor = UIColor(named: "AccentColor")
    }
}
