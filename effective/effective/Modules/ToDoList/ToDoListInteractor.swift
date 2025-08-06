//
//  TodoListInteractor.swift
//  effective
//
//  Created by Al Stark on 06.08.2025.
//

import CoreData

protocol TodoListInteractorProtocol {
    func fetchTodos(completion: @escaping (Result<[CDTodo], Error>) -> Void)
    func searchTodos(query: String, completion: @escaping (Result<[CDTodo], Error>) -> Void)
    func deleteTodo(_ todo: CDTodo, completion: @escaping (Result<Void, Error>) -> Void)
    func updateTodo(
        _ todo: CDTodo,
        completed: Bool,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class TodoListInteractor: TodoListInteractorProtocol {
    private let apiService: APIServiceProtocol
    private let persistence = PersistenceService.shared
    private var isFirstLoad: Bool {
        get { !UserDefaults.standard.bool(forKey: "didLoadAPI") }
        set { UserDefaults.standard.set(!newValue, forKey: "didLoadAPI") }
    }
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func fetchTodos(completion: @escaping (Result<[CDTodo], Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            if self.isFirstLoad {
                self.apiService.fetchTodos { result in
                    switch result {
                    case .success(let dtos):
                        self.save(dtos: dtos)
                        self.isFirstLoad = false
                        self.loadFromCoreData(completion)
                    case .failure(let error):
                        DispatchQueue.main.async { completion(.failure(error)) }
                    }
                }
            } else {
                self.loadFromCoreData(completion)
            }
        }
    }
    
    func searchTodos(query: String, completion: @escaping (Result<[CDTodo], Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            if query.isEmpty {
                self.loadFromCoreData(completion)
                return
            }
            
            let request: NSFetchRequest<CDTodo> = CDTodo.fetchRequest()
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", query)
            do {
                let results = try self.persistence.context.fetch(request)
                DispatchQueue.main.async { completion(.success(results)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }
    
    func deleteTodo(_ todo: CDTodo, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let ctx = self.persistence.context
            ctx.delete(todo)
            do {
                try ctx.save()
                DispatchQueue.main.async { completion(.success(())) }
            } catch {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }
    
    func updateTodo(
        _ todo: CDTodo,
        completed: Bool,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            todo.completed = completed
            self.persistence.saveContext()
            DispatchQueue.main.async {
                completion(.success(()))
            }
        }
    }
    
    private func loadFromCoreData(_ completion: @escaping (Result<[CDTodo], Error>) -> Void) {
        let request: NSFetchRequest<CDTodo> = CDTodo.fetchRequest()
        do {
            let items = try persistence.context.fetch(request)
            DispatchQueue.main.async { completion(.success(items)) }
        } catch {
            DispatchQueue.main.async { completion(.failure(error)) }
        }
    }
    
    private func save(dtos: [TodoDTO]) {
        let ctx = persistence.context
        dtos.forEach { dto in
            let cd = CDTodo(context: ctx)
            cd.id = Int64(dto.id)
            cd.title = dto.todo
            cd.completed = dto.completed
            cd.createdAt = dto.createAt ?? Date()
            cd.details = dto.description
        }
        persistence.saveContext()
    }
}
