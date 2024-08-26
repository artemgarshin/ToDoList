//
//  TaskInteractorProtocol.swift
//  ToDoList
//
//  Created by Артем Гаршин on 26.08.2024.
//

protocol TaskListInteractorProtocol: AnyObject {
    func fetchTasks()
    func addTask(_ task: Task)
    func updateTask(_ task: Task)
    func deleteTask(_ task: Task)
}
