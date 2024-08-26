//
//  TaskListPresenterProtocol.swift
//  ToDoList
//
//  Created by Артем Гаршин on 26.08.2024.
//

protocol TaskListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectTask(_ task: Task)
    func didTapAddTask(title: String, description: String)
    func didTapEditTask(_ task: Task)
    func didTapDeleteTask(_ task: Task)
}
