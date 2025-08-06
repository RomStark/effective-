//
//  ToDoListPresenter.swift
//  effective
//
//  Created by Al Stark on 06.08.2025.
//

import Foundation

protocol TodoListPresenterProtocol: AnyObject {
    func loadTodos()
    func search(_ query: String)
    func didTapAddNew()
    func didSelectTodo(at index: Int)
    func deleteTodo(at index: Int)
    func toggleCompleted(at index: Int)
}

final class TodoListPresenter: TodoListPresenterProtocol {
    weak var view: TodoListViewProtocol?
    let interactor: TodoListInteractorProtocol
    let router: TodoListRouterProtocol
    
    private var cdTodos: [CDTodo] = []
    
    init(interactor: TodoListInteractorProtocol, router: TodoListRouterProtocol) {
        self.interactor = interactor; self.router = router
    }
    
    func loadTodos() {
        interactor.fetchTodos { [weak self] result in
            switch result {
            case .success(let items):
                self?.cdTodos = items
                let vms = items.map(TodoViewModel.init)
                self?.view?.displayTodos(vms)
            case .failure(_):
                self?.view?.displayTodos([])
            }
        }
    }
    
    func search(_ query: String) {
        interactor.searchTodos(query: query) { [weak self] result in
            switch result {
            case .success(let items):
                self?.cdTodos = items
                let vms = items.map(TodoViewModel.init)
                self?.view?.displayTodos(vms)
            case .failure:
                self?.view?.displayTodos([])
            }
        }
    }
    
    func didTapAddNew() {
        router.openRedactor(for: nil)
    }
    
    func didSelectTodo(at index: Int) {
        guard index < cdTodos.count else { return }
        let cd = cdTodos[index]
        router.openRedactor(for: cd)
    }
    
    func deleteTodo(at index: Int) {
        guard index < cdTodos.count else { return }
        let todo = cdTodos[index]
        interactor.deleteTodo(todo) { [weak self] result in
            switch result {
            case .success:
                self?.loadTodos()
            case .failure(let error):
                print("Delete error:", error)
            }
        }
    }
    
    func toggleCompleted(at index: Int) {
        let cd = cdTodos[index]
        interactor.updateTodo(cd, completed: !cd.completed) { [weak self] result in
            switch result {
            case .success:
                self?.loadTodos()
            case .failure(let error):
                print("Delete error:", error)
            }
        }
    }
}
