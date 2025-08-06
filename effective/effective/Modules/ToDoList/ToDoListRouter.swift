//
//  ToDoListRouter.swift
//  effective
//
//  Created by Al Stark on 06.08.2025.
//

import UIKit

protocol TodoListRouterProtocol {
    func openRedactor(for todo: CDTodo?)
}

final class TodoListRouter: TodoListRouterProtocol {
    weak var viewController: UIViewController?
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
   
    func openRedactor(for todo: CDTodo?) {
        let assembly = TodoFormAssembly(navigationController: navigationController)
        navigationController.pushViewController(assembly.assemble(with: todo), animated: true)
    }
}
