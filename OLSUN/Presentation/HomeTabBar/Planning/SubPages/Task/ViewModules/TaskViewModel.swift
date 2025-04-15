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
    var taskItem: TaskItem?
        
    init(navigation: PlanningNavigation, taskItem: TaskItem?) {
        self.navigation = navigation
        self.taskItem = taskItem
    }
}
