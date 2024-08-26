//
//  TaskListInteractorOutputProtocol.swift
//  ToDoList
//
//  Created by Артем Гаршин on 26.08.2024.
//

protocol TaskListInteractorOutputProtocol: AnyObject {
    func didFetchTasks(_ tasks: [Task])
    func didUpdateTasks(_ tasks: [Task])
}
