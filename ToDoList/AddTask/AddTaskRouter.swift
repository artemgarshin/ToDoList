//
//  AddTaskRouter.swift
//  ToDoList
//
//  Created by Артем Гаршин on 27.08.2024.
//

import UIKit

protocol AddTaskRouterProtocol: AnyObject {
    func dismissAddTaskView()
}

class AddTaskRouter: AddTaskRouterProtocol {
    weak var viewController: UIViewController?

    func dismissAddTaskView() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
