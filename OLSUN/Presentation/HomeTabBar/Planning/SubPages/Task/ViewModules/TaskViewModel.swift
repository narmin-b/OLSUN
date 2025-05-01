//
//  TaskViewModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 13.04.25.
//

import Foundation

final class TaskViewModel {
    enum ViewState {
        case loading
        case loaded
        case success
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
    private weak var navigation: PlanningNavigation?
    var taskItem: ListCellProtocol
    private var taskUseCase: PlanningUseCase
    
    init(navigation: PlanningNavigation, taskUseCase: PlanningUseCase, taskItem: ListCellProtocol) {
        self.navigation = navigation
        self.taskUseCase = taskUseCase
        self.taskItem = taskItem
        Logger.debug("\(taskItem)")
    }
    
    // MARK: Navigations
    func popControllerBack() {
        navigation?.popController()
    }
    
    func showEditTask() {
        let task = ListCellProtocol(
            titleString: taskItem.titleString,
            dateString: taskItem.dateString,
            statusString: taskItem.statusString,
            idInt: taskItem.idInt
        )
        
        navigation?.showEditTask(taskItem: task) { [weak self] updatedTask in
            guard let self = self else { return }
            self.taskItem = updatedTask
            self.requestCallback?(.success)
        }
    }
    
    // MARK: Requests
    func editTask(task: PlanDataModel) {
        requestCallback?(.loading)
        taskUseCase.editPlan(plan: task) { [weak self] result, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if result != nil {
                    return
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
}
