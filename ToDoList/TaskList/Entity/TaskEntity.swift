//
//  TaskEntity.swift
//  ToDoList
//
//  Created by Артем Гаршин on 26.08.2024.
//

import Foundation

struct Task {
    let id: UUID
    var title: String
    var description: String
    var dateCreated: Date
    var isCompleted: Bool
}
