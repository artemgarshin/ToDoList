//
//  AddTaskInteractor.swift
//  ToDoList
//
//  Created by Артем Гаршин on 27.08.2024.
//
import Foundation

protocol AddTaskInteractorProtocol: AnyObject {
    func saveTask(_ task: Task)
    func updateTask(_ task: Task)
}

class AddTaskInteractor: AddTaskInteractorProtocol {
    weak var presenter: AddTaskInteractorOutputProtocol?
    var taskListInteractor: TaskListInteractorProtocol!

    func saveTask(_ task: Task) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.taskListInteractor.addTask(task)

            DispatchQueue.main.async {
                self?.presenter?.taskSavedSuccessfully()
            }
        }
    }

    func updateTask(_ task: Task) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.taskListInteractor.updateTask(task)

            DispatchQueue.main.async {
                self?.presenter?.taskSavedSuccessfully()
            }
        }
    }
}
