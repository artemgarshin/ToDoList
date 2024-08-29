//
//  TaskListInteractor.swift
//  ToDoList
//
//  Created by Артем Гаршин on 26.08.2024.
//

import Foundation

import Foundation

class TaskListInteractor: TaskListInteractorProtocol {
    weak var presenter: TaskListInteractorOutputProtocol?
    private var tasks: [Task] = []

    func fetchTasks() {
        if tasks.isEmpty {
            loadTasksFromAPI()
        } else {
            presenter?.didFetchTasks(tasks)
        }
    }

    private func loadTasksFromAPI() {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                // Обработка ошибки
                return
            }

            do {
                let todoResponse = try JSONDecoder().decode(TodoResponse.self, from: data)
                
                // Конвертация `Todo` в `Task`
                self?.tasks = todoResponse.todos.map { todo in
                    Task(id: UUID(), title: todo.todo, description: "", dateCreated: Date(), isCompleted: todo.completed)
                }

                DispatchQueue.main.async {
                    self?.presenter?.didFetchTasks(self?.tasks ?? [])
                }
            } catch {
                print("Ошибка декодирования данных: \(error)")
            }
        }

        task.resume()
    }

    func addTask(_ task: Task) {
        tasks.append(task)
        presenter?.didUpdateTasks(tasks)
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
        tasks.removeAll { $0.id == task.id }
        presenter?.didUpdateTasks(tasks)
    }
}
