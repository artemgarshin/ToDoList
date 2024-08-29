//
//  TaskListRouter.swift
//  ToDoList
//
//  Created by Артем Гаршин on 26.08.2024.
//

import UIKit

class TaskListRouter: TaskListRouterProtocol {
    weak var viewController: UIViewController?
    var interactor: TaskListInteractorProtocol?

    func navigateToTaskDetail(with task: Task) {
        guard let interactor = interactor else { return }
        let addTaskViewController = AddTaskModuleBuilder.build(with: interactor)
        if let addTaskVC = addTaskViewController as? AddTaskViewController {
            addTaskVC.taskToEdit = task
        }
        
        // Презентация модального экрана
        addTaskViewController.modalPresentationStyle = .formSheet
        viewController?.present(addTaskViewController, animated: true, completion: nil)
    }

    func navigateToAddTask() {
        guard let interactor = interactor else { return }
        let addTaskViewController = AddTaskModuleBuilder.build(with: interactor)
        
        // Презентация модального экрана
        addTaskViewController.modalPresentationStyle = .formSheet
        viewController?.present(addTaskViewController, animated: true, completion: nil)
    }
}
