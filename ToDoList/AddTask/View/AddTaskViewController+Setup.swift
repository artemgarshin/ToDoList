//
//  AddTaskViewController+Setup.swift
//  ToDoList
//
//  Created by Артем Гаршин on 29.08.2024.
//

import UIKit

extension AddTaskViewController {
    func setupUI() {
        view.backgroundColor = .white
        title = taskToEdit == nil ? "Add Task" : "Edit Task"

        setupTitleTextField()
        setupDescriptionTextView()
        setupPlaceholder()

        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textColor = .gray
        dateLabel.textAlignment = .center

        saveButton.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        cancelButton.tintColor = .systemRed

        setupStackView()
    }

    func setupTitleTextField() {
        titleTextField.placeholder = "Task Title"
        titleTextField.borderStyle = .none
        titleTextField.font = UIFont.boldSystemFont(ofSize: 24)
        titleTextField.textColor = .black
        titleTextField.textAlignment = .left
    }

    func setupDescriptionTextView() {
        descriptionTextView.layer.cornerRadius = 8.0
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        descriptionTextView.textColor = .black
        descriptionTextView.textAlignment = .left
        descriptionTextView.isScrollEnabled = true
        descriptionTextView.showsVerticalScrollIndicator = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupPlaceholder() {
        placeholderLabel.text = "Enter description..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: descriptionTextView.font?.pointSize ?? 16)
        placeholderLabel.sizeToFit()
        placeholderLabel.textColor = .lightGray
        placeholderLabel.isHidden = !descriptionTextView.text.isEmpty

        descriptionTextView.addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor, constant: 5),
            placeholderLabel.topAnchor.constraint(equalTo: descriptionTextView.topAnchor, constant: 8)
        ])
    }

    func setupStackView() {
        let mainStackView = UIStackView(arrangedSubviews: [titleTextField, descriptionTextView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill

        let buttonStackView = UIStackView(arrangedSubviews: [saveButton, cancelButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 16
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .fillEqually

        let bottomStackView = UIStackView(arrangedSubviews: [buttonStackView, dateLabel])
        bottomStackView.axis = .vertical
        bottomStackView.spacing = 16
        bottomStackView.alignment = .center
        bottomStackView.distribution = .fill

        view.addSubview(mainStackView)
        view.addSubview(bottomStackView)

        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStackView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: -20),

            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bottomStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}
