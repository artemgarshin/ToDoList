//
//  TaskListPresenter.swift
//  ToDoList
//
//  Created by Артем Гаршин on 26.08.2024.
//

import Foundation

class TaskListPresenter: TaskListPresenterProtocol {
    weak var view: TaskListViewProtocol?
    var interactor: TaskListInteractorProtocol!
    var router: TaskListRouterProtocol!

    func viewDidLoad() {
        interactor.fetchTasks()
    }

    func didSelectTask(_ task: Task) {
        router.navigateToTaskDetail(with: task)
    }

    func didTapAddTask(title: String, description: String) {
        let task = Task(id: UUID(), title: title, description: description, dateCreated: Date(), isCompleted: false)
        interactor.addTask(task)
    }

    func didTapEditTask(_ task: Task) {
        interactor.updateTask(task)
    }
    func didTapDeleteTask(_ task: Task) {
        interactor.deleteTask(task)
    }
    
    func didTapAddTaskButton() {
        router.navigateToAddTask()
    }
}

extension TaskListPresenter: TaskListInteractorOutputProtocol {
    func didFetchTasks(_ tasks: [Task]) {
        view?.showTasks(tasks)
    }

    func didUpdateTasks(_ tasks: [Task]) {
        view?.showTasks(tasks)
    }
}
