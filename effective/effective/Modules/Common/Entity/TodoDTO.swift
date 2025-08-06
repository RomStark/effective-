//
//  TodoDTO.swift
//  effective
//
//  Created by Al Stark on 06.08.2025.
//

import Foundation

struct TodoDTO: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
    let createAt: Date?
    let description: String?
}
