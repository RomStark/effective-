//
//  TodoFormAssembly.swift
//  effective
//
//  Created by Al Stark on 06.08.2025.
//

import UIKit

final class TodoFormAssembly {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func assemble(with todo: CDTodo?) -> UIViewController {
        let interactor = TodoFormInteractor(persistence: PersistenceService.shared)
        let router = TodoFormRouter(navigationController: navigationController)
        let presenter = TodoFormPresenter(interactor: interactor, router: router, todo: todo)
        let vc = TodoFormViewController(presenter: presenter)
        
        presenter.view = vc
        router.viewController = vc
        return vc
    }
}
