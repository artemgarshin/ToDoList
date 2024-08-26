//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by Артем Гаршин on 26.08.2024.
//

import UIKit

class TaskListViewController: UIViewController, TaskListViewProtocol {
    var presenter: TaskListPresenterProtocol!
    private var tasks: [Task] = []
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        // Установка цвета фона для основного view
        view.backgroundColor = .white

        // Добавление UITableView на основное view
        view.addSubview(tableView)
        
        // Настройка UITableView
        tableView.dataSource = self
        tableView.delegate = self
        
        // Установка цвета фона для UITableView
        tableView.backgroundColor = .white
        
        // Настройка констрейнтов или фреймов для tableView (если это еще не сделано)
        tableView.frame = view.bounds
    }
    func showTasks(_ tasks: [Task]) {
        self.tasks = tasks
        tableView.reloadData()
    }

    func showError(_ message: String) {
        // Отображение ошибки пользователю
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "TaskCell")
        
        let task = tasks[indexPath.row]
        
        cell.textLabel?.text = task.title
        cell.detailTextLabel?.text = task.isCompleted ? "Completed" : "Not Completed"
        
        // Установка цвета фона для ячейки
        cell.backgroundColor = .white
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        presenter.didSelectTask(task)
    }
}
