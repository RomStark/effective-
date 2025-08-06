//
//  TodoFormPresenter.swift
//  effective
//
//  Created by Al Stark on 06.08.2025.
//

protocol TodoFormPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapSave(title: String?, details: String?)
    func didTapCancel()
}

final class TodoFormPresenter: TodoFormPresenterProtocol {
    weak var view: TodoFormViewProtocol?
    private let interactor: TodoFormInteractorProtocol
    private let router: TodoFormRouterProtocol
    private let todo: CDTodo?
    
    init(interactor: TodoFormInteractorProtocol, router: TodoFormRouterProtocol, todo: CDTodo?) {
        self.interactor = interactor
        self.router = router
        self.todo = todo
    }
    
    func viewDidLoad() {
        if let cd = todo {
            view?.display(todo: TodoViewModel(from: cd))
        } else {
            view?.display(todo: nil)
        }
    }
    
    func didTapSave(title: String?, details: String?) {
        guard let title = title, !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            view?.showError("Заголовок не должен быть пустым")
            return
        }
        
        if let cd = todo {
            interactor.updateTodo(cd, title: title, details: details) { [weak self] result in
                switch result {
                case .success(): self?.router.dismiss()
                case .failure(let e): self?.view?.showError(e.localizedDescription)
                }
            }
        } else {
            interactor.createTodo(title: title, details: details, completed: false) { [weak self] result in
                switch result {
                case .success(): self?.router.dismiss()
                case .failure(let e): self?.view?.showError(e.localizedDescription)
                }
            }
        }
    }
    
    func didTapCancel() {
        router.dismiss()
    }
}
