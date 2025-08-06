//
//  TodoViewModel.swift
//  effective
//
//  Created by Al Stark on 06.08.2025.
//

import Foundation

struct TodoViewModel {
    let id: Int64
    let title: String
    let subtitle: String
    let isCompleted: Bool
    let createAt: String?
    
    init(from cd: CDTodo) {
        id = cd.id
        title = cd.title ?? ""
        subtitle = (cd.details ?? "")
        isCompleted = cd.completed
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        if let date = cd.createdAt {
            createAt = formatter.string(from: date)
        } else {
            createAt = nil
        }
    }
}
