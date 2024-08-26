//
//  TaskListInteractor.swift
//  ToDoList
//
//  Created by Артем Гаршин on 26.08.2024.
//

import Foundation

class TaskListInteractor: TaskListInteractorProtocol {
    weak var presenter: TaskListInteractorOutputProtocol?
    private var tasks: [Task] = []

    func fetchTasks() {
        // Добавление тестовых данных
        tasks = [
            Task(id: UUID(), title: "Купить продукты", description: "Купить хлеб, молоко и сыр", dateCreated: Date(), isCompleted: false),
            Task(id: UUID(), title: "Написать отчёт", description: "Написать отчёт по проекту для клиента", dateCreated: Date(), isCompleted: false),
            Task(id: UUID(), title: "Позвонить в банк", description: "Узнать информацию о кредите", dateCreated: Date(), isCompleted: true)
        ]

        presenter?.didFetchTasks(tasks)
    }

    func addTask(_ task: Task) {
        tasks.append(task)
        presenter?.didUpdateTasks(tasks)
    }

    func updateTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            presenter?.didUpdateTasks(tasks)
        }
    }

    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
        presenter?.didUpdateTasks(tasks)
    }
}
