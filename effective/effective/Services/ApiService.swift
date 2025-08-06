//
//  ApiService.swift
//  effective
//
//  Created by Al Stark on 06.08.2025.
//

import Foundation

protocol APIServiceProtocol {
    func fetchTodos(completion: @escaping (Result<[TodoDTO], Error>) -> Void)
}

final class APIService: APIServiceProtocol {
    private let url = URL(string: "https://dummyjson.com/todos")!
    func fetchTodos(completion: @escaping (Result<[TodoDTO], Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let err = error { return completion(.failure(err)) }
            guard let data = data else { return completion(.failure(NSError())) }
            do {
                struct Response: Codable { let todos: [TodoDTO] }
                let resp = try JSONDecoder().decode(Response.self, from: data)
                completion(.success(resp.todos))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
