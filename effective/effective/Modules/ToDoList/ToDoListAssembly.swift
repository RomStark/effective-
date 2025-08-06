//
//  ToDoListAssembly.swift
//  effective
//
//  Created by Al Stark on 06.08.2025.
//

import UIKit

final class TodoListAssembly {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func assemble() -> UIViewController {
        let api = APIService()
        let interactor = TodoListInteractor(apiService: api)
        let router = TodoListRouter(navigationController: navigationController)
        let presenter = TodoListPresenter(interactor: interactor, router: router)
        let viewController = TodoListViewController(presenter: presenter)
        
        presenter.view = viewController
        router.viewController = viewController
        return viewController
    }
}
