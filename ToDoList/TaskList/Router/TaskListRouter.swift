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
        if var addTaskVC = addTaskViewController as? AddTaskViewController {
            addTaskVC.taskToEdit = task
        }
        viewController?.navigationController?.pushViewController(addTaskViewController, animated: true)
    }



    func navigateToAddTask() {
        guard let interactor = interactor else { return }
        let addTaskViewController = AddTaskModuleBuilder.build(with: interactor)
        viewController?.navigationController?.pushViewController(addTaskViewController, animated: true)
    }
}
