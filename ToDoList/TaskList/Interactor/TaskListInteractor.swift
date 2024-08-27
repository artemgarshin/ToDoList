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
        // Выполнение загрузки задач на фоне
        DispatchQueue.global(qos: .background).async { [weak self] in
            // Эмуляция загрузки данных, например, из базы данных
            self?.presenter?.didFetchTasks(self?.tasks ?? [])
        }
    }

    func addTask(_ task: Task) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.tasks.append(task)

            // Возвращение на главный поток для обновления UI
            DispatchQueue.main.async {
                self?.presenter?.didUpdateTasks(self?.tasks ?? [])
            }
        }
    }

    func updateTask(_ task: Task) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let index = self?.tasks.firstIndex(where: { $0.id == task.id }) {
                self?.tasks[index] = task

                DispatchQueue.main.async {
                    self?.presenter?.didUpdateTasks(self?.tasks ?? [])
                }
            }
        }
    }

    func deleteTask(_ task: Task) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.tasks.removeAll { $0.id == task.id }

            DispatchQueue.main.async {
                self?.presenter?.didUpdateTasks(self?.tasks ?? [])
            }
        }
    }
}
