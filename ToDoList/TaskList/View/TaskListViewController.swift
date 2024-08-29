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
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
    
    @objc private func toggleTaskCompletion(_ sender: UIButton) {
        let taskIndex = sender.tag
        var task = tasks[taskIndex]
        
        // Переключение статуса выполнения
        task.isCompleted.toggle()
        
        tasks[taskIndex] = task
        tableView.reloadData()

        presenter.didTapEditTask(task)
    }
}

extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "TaskCell")
        
        let task = tasks[indexPath.row]

        // Настройка основного текста и даты
        cell.textLabel?.text = task.title
        cell.detailTextLabel?.text = formatDate(task.dateCreated)

        // Переиспользование или создание чекбокса
        let checkBox: UIButton
        if let existingCheckBox = cell.accessoryView as? UIButton {
            checkBox = existingCheckBox
        } else {
            checkBox = UIButton(type: .system)
            checkBox.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            cell.accessoryView = checkBox
        }
        
        // Настройка чекбокса
        checkBox.setTitle(task.isCompleted ? "☑️" : "⬜️", for: .normal)
        checkBox.addTarget(self, action: #selector(toggleTaskCompletion(_:)), for: .touchUpInside)
        checkBox.tag = indexPath.row // Сохраняем индекс задачи в тэге кнопки
        
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
