//
//  TodoFormInteractor.swift
//  effective
//
//  Created by Al Stark on 06.08.2025.
//

import Foundation

protocol TodoFormInteractorProtocol {
    func createTodo(
        title: String,
        details: String?,
        completed: Bool,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    func updateTodo(
        _ cdTodo: CDTodo,
        title: String,
        details: String?,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class TodoFormInteractor: TodoFormInteractorProtocol {
    private let persistence: PersistenceService
    
    init(persistence: PersistenceService) {
        self.persistence = persistence
    }
    
    func createTodo(title: String, details: String?, completed: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let ctx = self.persistence.context
            let cd = CDTodo(context: ctx)
            cd.id = Int64(Date().timeIntervalSince1970)
            cd.title = title
            cd.details = details
            cd.completed = completed
            cd.createdAt = Date()
            self.persistence.saveContext()
            DispatchQueue.main.async { completion(.success(())) }
        }
    }
    
    func updateTodo(_ cdTodo: CDTodo, title: String, details: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            cdTodo.title = title
            cdTodo.details = details
            self.persistence.saveContext()
            DispatchQueue.main.async { completion(.success(())) }
        }
    }
}
