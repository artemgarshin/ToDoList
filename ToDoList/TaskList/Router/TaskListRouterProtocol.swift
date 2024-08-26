//
//  TaskListRouterProtocol.swift
//  ToDoList
//
//  Created by Артем Гаршин on 26.08.2024.
//

protocol TaskListRouterProtocol: AnyObject {
    func navigateToTaskDetail(with task: Task)
    func navigateToAddTask()
}
