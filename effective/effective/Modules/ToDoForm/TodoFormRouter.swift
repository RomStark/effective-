//
//  TodoFormRouter.swift
//  effective
//
//  Created by Al Stark on 06.08.2025.
//

import UIKit

protocol TodoFormRouterProtocol {
    func dismiss()
}

final class TodoFormRouter: TodoFormRouterProtocol {
    weak var viewController: UIViewController?
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func dismiss() {
        navigationController.popViewController(animated: true)
    }
}
