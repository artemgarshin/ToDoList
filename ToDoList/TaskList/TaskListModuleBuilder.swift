//
//  TaskListModuleBuilder.swift
//  ToDoList
//
//  Created by Артем Гаршин on 26.08.2024.
//

import UIKit

class TaskListModuleBuilder {
    static func build() -> UIViewController {
        let view = TaskListViewController()
        let interactor = TaskListInteractor()
        let presenter = TaskListPresenter()
        let router = TaskListRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        router.interactor = interactor

        return view
    }
}
