//
//  PlanningNavigation.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 12.04.25.
//

import Foundation

protocol PlanningNavigation: AnyObject {
    func showTask(taskItem: TaskItem)
    func showAddTask()
}
