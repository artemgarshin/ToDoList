//
//  AddTaskPresenter.swift
//  ToDoList
//
//  Created by Артем Гаршин on 27.08.2024.
//

import Foundation

protocol AddTaskInteractorOutputProtocol: AnyObject {
    func taskSavedSuccessfully()
}

protocol AddTaskPresenterProtocol: AnyObject {
    func saveTask(title: String, description: String)
    func updateTask(_ task: Task, title: String, description: String)
    func handleInvalidInput()
}

class AddTaskPresenter: AddTaskPresenterProtocol {
    weak var view: AddTaskViewProtocol?
    var interactor: AddTaskInteractorProtocol!
    var router: AddTaskRouterProtocol!

    func saveTask(title: String, description: String) {
        let task = Task(id: UUID(), title: title, description: description, dateCreated: Date(), isCompleted: false)
        interactor.saveTask(task)
    }

    func updateTask(_ task: Task, title: String, description: String) {
        var updatedTask = task
        updatedTask.title = title
        updatedTask.description = description
        interactor.updateTask(updatedTask)
    }

    func handleInvalidInput() {
        view?.showError("Please fill in all fields.")
    }
}
extension AddTaskPresenter: AddTaskInteractorOutputProtocol {
    func taskSavedSuccessfully() {
        router.dismissAddTaskView()
    }
}
