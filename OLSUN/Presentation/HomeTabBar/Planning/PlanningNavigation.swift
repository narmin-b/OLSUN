//
//  PlanningNavigation.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 12.04.25.
//

import Foundation

protocol PlanningNavigation: AnyObject {
    func showTask(taskItem: ListCellProtocol)
    func showEditTask(taskItem: ListCellProtocol, onUpdate: @escaping (ListCellProtocol) -> Void)
    func showAddTask()
    func popController()
    func popTwoControllersBack()
    func showProfile()
}
