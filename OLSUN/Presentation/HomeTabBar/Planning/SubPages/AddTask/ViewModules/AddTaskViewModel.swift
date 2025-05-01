//
//  AddTaskViewModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 13.04.25.
//

import Foundation

enum TaskMode {
    case edit
    case add
}

final class AddTaskViewModel {
    enum ViewState {
        case loading
        case loaded
        case editSuccess(guest: ListCellProtocol)
        case deleteSuccess
        case success
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
    private weak var navigation: PlanningNavigation?
    private var taskUseCase: PlanningUseCase
    var taskMode: TaskMode
    var taskItem: ListCellProtocol
    
    init(navigation: PlanningNavigation, taskUseCase: PlanningUseCase, taskMode: TaskMode, taskItem: ListCellProtocol) {
        self.navigation = navigation
        self.taskUseCase = taskUseCase
        self.taskMode = taskMode
        self.taskItem = taskItem
        Logger.debug("\(taskItem)")
        Logger.debug("\(taskMode)")
    }
    
    // MARK: Navigations
    func popControllerBack() {
        navigation?.popController()
    }
    
    // MARK: Requests
    func performEdit(task: PlanDataModel) {
        switch taskMode {
        case .edit:
            editTask(task: task)
        case .add:
            addTask(task: task)
        }
    }
    
    func addTask(task: PlanDataModel) {
        requestCallback?(.loading)
        taskUseCase.addPlan(plan: task) { [weak self] result, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if result != nil {
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func editTask(task: PlanDataModel) {
        requestCallback?(.loading)
        taskUseCase.editPlan(plan: task) { [weak self] result, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if result != nil {
                    let newTask = task.mapToDomain()
                    self.requestCallback?(.editSuccess(guest: newTask))
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func deleteTask(id: Int) {
        requestCallback?(.loading)
        taskUseCase.deletePlan(id: id) { [weak self] result, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if result != nil {
                    self.navigation?.popTwoControllersBack()
                    self.requestCallback?(.deleteSuccess)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
}
