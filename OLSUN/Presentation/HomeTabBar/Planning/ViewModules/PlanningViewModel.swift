//
//  PlanningViewModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 12.04.25.
//

import Foundation

final class PlanningViewModel {
    enum ViewState {
        case refreshError(message: String)
        case loading
        case loaded
        case success
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
    private weak var navigation: PlanningNavigation?
    private var taskUseCase: PlanningUseCase
    var taskList: [ListCellProtocol] = []
    
    init(navigation: PlanningNavigation, taskUseCase: PlanningUseCase) {
        self.navigation = navigation
        self.taskUseCase = taskUseCase
    }
    
    // MARK: Navigations
    func taskSelected(taskItem: ListCellProtocol) {
        navigation?.showTask(taskItem: taskItem)
    }
    
    func showAddTaskVC() {
        navigation?.showAddTask()
    }
    
    func showProfileScreen() {
        navigation?.showProfile()
    }
    
    // MARK: Requests
    func getAllTasks() {
        requestCallback?(.loading)
        taskUseCase.getPlanList { [weak self] result, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if let result = result {
                    self.taskList = (result.map({$0.mapToDomain()}))
                    Logger.debug("\(self.taskList)")
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func refreshAllTasks() {
        taskUseCase.getPlanList { [weak self] result, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let result = result {
                    self.taskList = (result.map({$0.mapToDomain()}))
                    Logger.debug("/(self.taskList)")
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.refreshError(message: error))
                }
            }
        }
    }
}
