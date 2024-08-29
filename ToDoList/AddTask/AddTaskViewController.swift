import UIKit

protocol AddTaskViewProtocol: AnyObject {
    func showError(_ message: String)
}

class AddTaskViewController: UIViewController, AddTaskViewProtocol {
    var presenter: AddTaskPresenterProtocol!

    private let titleTextField = UITextField()
    private let descriptionTextField = UITextField()
    private let saveButton = UIButton(type: .system)
    private let dateLabel = UILabel()
    private let cancelButton = UIButton(type: .system)

    var taskToEdit: Task?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        if let task = taskToEdit {
            titleTextField.text = task.title
            descriptionTextField.text = task.description
            dateLabel.text = "Created: \(formatDate(task.dateCreated))"
            saveButton.setTitle("Update", for: .normal)
        } else {
            saveButton.setTitle("Save", for: .normal)
            dateLabel.isHidden = true // Скрываем дату, если задача новая
        }
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = taskToEdit == nil ? "Add Task" : "Edit Task"

        titleTextField.placeholder = "Task Title"
        descriptionTextField.placeholder = "Task Description"

        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textColor = .gray

        saveButton.addTarget(self, action: #selector(saveTask), for: .touchUpInside)

        // Настройка кнопки Cancel
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [titleTextField, descriptionTextField, dateLabel, saveButton, cancelButton])
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
        guard let title = titleTextField.text, !title.isEmpty else {
            presenter.handleInvalidInput()
            return
        }

        let description = descriptionTextField.text?.isEmpty == true ? nil : descriptionTextField.text

        if let task = taskToEdit {
            presenter.updateTask(task, title: title, description: description)
        } else {
            presenter.saveTask(title: title, description: description)
        }

        // Закрытие экрана должно происходить на главном потоке
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }

    @objc private func cancel() {
        dismiss(animated: true, completion: nil) // Закрытие экрана без изменений
    }

    func showError(_ message: String) {
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
}
