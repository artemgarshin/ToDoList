//
//  ToDoListTests.swift
//  ToDoListTests
//
//  Created by Артем Гаршин on 26.08.2024.
//

import XCTest
@testable import ToDoList

class TodoJSONParsingTests: XCTestCase {

    var todoResponse: TodoResponse?

    override func setUp() {
        super.setUp()

        // Загрузка JSON данных из файла в тестовом бандле
        if let url = Bundle(for: type(of: self)).url(forResource: "todos", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                todoResponse = try decoder.decode(TodoResponse.self, from: data)
            } catch {
                XCTFail("Ошибка загрузки JSON: \(error.localizedDescription)")
            }
        } else {
            XCTFail("Файл todos.json не найден")
        }
    }

    func testJSONParsing() {
        XCTAssertNotNil(todoResponse, "Не удалось распарсить JSON")

        if let todos = todoResponse?.todos {
            XCTAssertEqual(todos.count, 30, "Количество задач должно быть 30")
            let firstTodo = todos.first
            XCTAssertEqual(firstTodo?.id, 1, "Первый ID должен быть 1")
            XCTAssertEqual(firstTodo?.todo, "Do something nice for someone you care about", "Текст первой задачи некорректен")
            XCTAssertEqual(firstTodo?.completed, false, "Статус выполнения первой задачи некорректен")
        }
    }

    override func tearDown() {
        todoResponse = nil
        super.tearDown()
    }
}
