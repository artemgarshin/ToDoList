//
//  TaskListRouter.swift
//  ToDoList
//
//  Created by Артем Гаршин on 26.08.2024.
//

import UIKit

class TaskListRouter: TaskListRouterProtocol {
    weak var viewController: UIViewController?

    func navigateToTaskDetail(with task: Task) {
//        // Создайте и настройте контроллер для деталей задачи
//        let taskDetailViewController = TaskDetailViewController()
//        taskDetailViewController.task = task
//        viewController?.navigationController?.pushViewController(taskDetailViewController, animated: true)
    }

    func navigateToAddTask() {
//        // Создайте и настройте контроллер для добавления новой задачи
//        let addTaskViewController = AddTaskViewController()
//        viewController?.navigationController?.pushViewController(addTaskViewController, animated: true)
    }
}
