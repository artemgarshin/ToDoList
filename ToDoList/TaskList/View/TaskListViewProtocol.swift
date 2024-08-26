//
//  TaskListViewProtocol.swift
//  ToDoList
//
//  Created by Артем Гаршин on 26.08.2024.
//

protocol TaskListViewProtocol: AnyObject {
    func showTasks(_ tasks: [Task])
    func showError(_ message: String)
}
