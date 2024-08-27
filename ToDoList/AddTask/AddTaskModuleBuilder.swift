//
//  AddTaskModuleBuilder.swift
//  ToDoList
//
//  Created by Артем Гаршин on 27.08.2024.
//

import Foundation
import UIKit

class AddTaskModuleBuilder {
    static func build(with taskListInteractor: TaskListInteractorProtocol) -> UIViewController {
        let view = AddTaskViewController()
        let presenter = AddTaskPresenter()
        let interactor = AddTaskInteractor()
        let router = AddTaskRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        interactor.taskListInteractor = taskListInteractor
        router.viewController = view

        return view
    }
}
