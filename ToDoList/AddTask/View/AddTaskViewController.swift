import UIKit

protocol AddTaskViewProtocol: AnyObject {
    func showError(_ message: String)
}

class AddTaskViewController: UIViewController, UITextViewDelegate, AddTaskViewProtocol {
    var presenter: AddTaskPresenterProtocol!

    let titleTextField = UITextField() // Убираем private для доступа в расширении
    let descriptionTextView = UITextView()
    let placeholderLabel = UILabel() // Label для плейсхолдера
    let saveButton = UIButton(type: .system)
    let dateLabel = UILabel()
    let cancelButton = UIButton(type: .system)

    var taskToEdit: Task?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        descriptionTextView.delegate = self
        
        if let task = taskToEdit {
            titleTextField.text = task.title
            descriptionTextView.text = task.description
            placeholderLabel.isHidden = !(task.description?.isEmpty ?? true)
            dateLabel.text = "Created: \(formatDate(task.dateCreated))"
            saveButton.setTitle("Update", for: .normal)
        } else {
            saveButton.setTitle("Save", for: .normal)
            dateLabel.isHidden = true // Скрываем дату, если задача новая
            placeholderLabel.isHidden = false // Показываем плейсхолдер для новой задачи
        }
    }

    @objc func saveTask() {
        guard let title = titleTextField.text, !title.isEmpty else {
            presenter.handleInvalidInput()
            return
        }

        let description = descriptionTextView.text.isEmpty ? nil : descriptionTextView.text

        if let task = taskToEdit {
            presenter.updateTask(task, title: title, description: description)
        } else {
            presenter.saveTask(title: title, description: description)
        }

        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }

    @objc func cancel() {
        dismiss(animated: true, completion: nil)
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
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
