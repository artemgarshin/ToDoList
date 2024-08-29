//
//  TaskListInteractor.swift
//  ToDoList
//
//  Created by Артем Гаршин on 26.08.2024.
//

import Foundation
import CoreData

class TaskListInteractor: TaskListInteractorProtocol {
    weak var presenter: TaskListInteractorOutputProtocol?
    private var tasks: [Task] = []

    // MARK: - Fetch Tasks
    func fetchTasks() {
        let hasLoadedData = UserDefaults.standard.bool(forKey: "hasLoadedData")
        
        if !hasLoadedData {
            loadTasksFromAPI()
        } else {
            loadTasksFromCoreData()
        }
    }

    private func loadTasksFromCoreData() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            
            do {
                let taskEntities = try CoreDataStack.shared.context.fetch(request)
                self?.tasks = taskEntities.map { taskEntity in
                    Task(id: taskEntity.id ?? UUID(),
                         title: taskEntity.title ?? "Untitled",
                         description: taskEntity.descriptionText,
                         dateCreated: taskEntity.dateCreated ?? Date(),
                         isCompleted: taskEntity.isCompleted)
                }
                DispatchQueue.main.async {
                    self?.presenter?.didFetchTasks(self?.tasks ?? [])
                }
            } catch {
                print("Ошибка загрузки задач из Core Data: \(error)")
            }
        }
    }
    
    private func loadTasksFromAPI() {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            return
        }

        var request = URLRequest(url: url)
        request.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")

        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Ошибка загрузки данных из API: \(error?.localizedDescription ?? "Нет описания ошибки")")
                return
            }

            do {
                let todoResponse = try JSONDecoder().decode(TodoResponse.self, from: data)
                
                DispatchQueue.global(qos: .background).async {
                    self?.tasks = todoResponse.todos.map { todo in
                        let newTask = Task(id: UUID(), title: todo.todo, description: nil, dateCreated: Date(), isCompleted: todo.completed)
                        
                        let taskEntity = TaskEntity(context: CoreDataStack.shared.context)
                        taskEntity.id = newTask.id
                        taskEntity.title = newTask.title
                        taskEntity.descriptionText = newTask.description
                        taskEntity.dateCreated = newTask.dateCreated
                        taskEntity.isCompleted = newTask.isCompleted
                        
                        return newTask
                    }
                    
                    CoreDataStack.shared.saveContext()
                    
                    DispatchQueue.main.async {
                        self?.presenter?.didFetchTasks(self?.tasks ?? [])
                        UserDefaults.standard.set(true, forKey: "hasLoadedData")
                    }
                }
            } catch {
                print("Ошибка декодирования данных из API: \(error)")
            }
        }

        task.resume()
    }

    // MARK: - Add Task
    func addTask(_ task: Task) {
        DispatchQueue.global(qos: .background).async {
            let taskEntity = TaskEntity(context: CoreDataStack.shared.context)
            taskEntity.id = task.id
            taskEntity.title = task.title
            taskEntity.descriptionText = task.description
            taskEntity.dateCreated = task.dateCreated
            taskEntity.isCompleted = task.isCompleted

            CoreDataStack.shared.saveContext()

            DispatchQueue.main.async {
                self.fetchTasks()
            }
        }
    }

    // MARK: - Update Task
    func updateTask(_ task: Task) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
            
            do {
                let taskEntities = try CoreDataStack.shared.context.fetch(request)
                if let taskEntity = taskEntities.first {
                    taskEntity.title = task.title
                    taskEntity.descriptionText = task.description
                    taskEntity.isCompleted = task.isCompleted

                    CoreDataStack.shared.saveContext()
                    
                    DispatchQueue.main.async {
                        self?.fetchTasks()
                    }
                }
            } catch {
                print("Ошибка обновления задачи в Core Data: \(error)")
            }
        }
    }

    // MARK: - Delete Task
    func deleteTask(_ task: Task) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
            
            do {
                let taskEntities = try CoreDataStack.shared.context.fetch(request)
                if let taskEntity = taskEntities.first {
                    CoreDataStack.shared.context.delete(taskEntity)
                    CoreDataStack.shared.saveContext()

                    DispatchQueue.main.async {
                        self?.fetchTasks()
                    }
                }
            } catch {
                print("Ошибка удаления задачи из Core Data: \(error)")
            }
        }
    }
}
