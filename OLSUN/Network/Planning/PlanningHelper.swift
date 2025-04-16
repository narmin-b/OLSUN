//
//  PlanningHelper.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 16.04.25.
//

import Foundation

enum PlanningHelper {
    case addTask
    case editTask(id: Int)
    case allTasksList
    case deleteTask(id: Int)
    
    var endpoint: URL? {
        switch self {
        case .addTask:
            return CoreAPIHelper.instance.makeURL(path: "plan/planAdd")
        case .editTask(let id):
            return CoreAPIHelper.instance.makeURL(path: "plan/update-plan/\(id)")
        case .allTasksList:
            return CoreAPIHelper.instance.makeURL(path: "plan/by-user")
        case .deleteTask(let id):
            return CoreAPIHelper.instance.makeURL(path: "plan/delete/\(id)")
        }
    }
}
