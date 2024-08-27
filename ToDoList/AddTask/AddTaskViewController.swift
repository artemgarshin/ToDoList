//
//  AddTaskViewController.swift
//  ToDoList
//
//  Created by Артем Гаршин on 27.08.2024.
//

import UIKit

protocol AddTaskViewProtocol: AnyObject {
    func showError(_ message: String)
}

class AddTaskViewController: UIViewController, AddTaskViewProtocol {
    var presenter: AddTaskPresenterProtocol!

    private let titleTextField = UITextField()
    private let descriptionTextField = UITextField()
    private let saveButton = UIButton(type: .system)

    var taskToEdit: Task?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        if let task = taskToEdit {
            titleTextField.text = task.title
            descriptionTextField.text = task.description
            saveButton.setTitle("Update", for: .normal)
        } else {
            saveButton.setTitle("Save", for: .normal)
        }
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = taskToEdit == nil ? "Add Task" : "Edit Task"

        titleTextField.placeholder = "Task Title"
        descriptionTextField.placeholder = "Task Description"

        saveButton.addTarget(self, action: #selector(saveTask), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [titleTextField, descriptionTextField, saveButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    @objc private func saveTask() {
        guard let title = titleTextField.text, !title.isEmpty,
              let description = descriptionTextField.text, !description.isEmpty else {
            presenter.handleInvalidInput()
            return
        }

        if let task = taskToEdit {
            presenter.updateTask(task, title: title, description: description)
        } else {
            presenter.saveTask(title: title, description: description)
        }
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
