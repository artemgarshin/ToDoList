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
        view.backgroundColor = .white
        title = "Tasks"

        // Добавление кнопки "Добавить"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskTapped))

        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.backgroundColor = .white
        tableView.frame = view.bounds
    }

    @objc private func addTaskTapped() {
        presenter.didTapAddTaskButton()
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            presenter.didTapDeleteTask(task)
        }
    }
}
