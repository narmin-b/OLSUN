//
//  PlanningAPIService.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 16.04.25.
//

import Foundation

final class PlanningAPIService: PlanningUseCase {
    
    private let apiService = CoreAPIManager.instance
    
    func addPlan(plan: PlanDataModel, completion: @escaping (String?, String?) -> Void) {
        apiService.request(
            type: String.self,
            url: PlanningHelper.addTask.endpoint,
            method: .POST,
            header: ["Content-Type" : "application/json",
                     "Authorization" : "Bearer \(KeychainHelper.getString(key: .userID) ?? "")"],
            body: [
                "planTitle" : plan.planTitle,
                "deadline" : plan.deadline,
                "status" : plan.status.rawValue
            ]
        ) { [weak self] result in
            guard self != nil else { return }
            Logger.debug("result: \(result)")
            
            switch result {
            case .success(let (data, statusCode)):
                Logger.debug("Status Code: \(statusCode)")
                completion(data, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func getPlanList(completion: @escaping ([PlanDataModel]?, String?) -> Void) {
        apiService.request(
            type: [PlanDataModel].self,
            url: PlanningHelper.allTasksList.endpoint,
            method: .GET,
            header: ["Content-Type" : "application/json",
                     "Authorization" : "Bearer \(KeychainHelper.getString(key: .userID) ?? "")"],
            body: [ : ]
        ) { [weak self] result in
            guard self != nil else { return }
            Logger.debug("result: \(result)")
            
            switch result {
            case .success(let (data, statusCode)):
                Logger.debug("Status Code: \(statusCode)")
                completion(data, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func editPlan(plan: PlanDataModel, completion: @escaping (String?, String?) -> Void) {
        apiService.request(
            type: String.self,
            url: PlanningHelper.editTask(id: plan.id!).endpoint,
            method: .PUT,
            header: ["Content-Type" : "application/json",
                     "Authorization" : "Bearer \(KeychainHelper.getString(key: .userID) ?? "")"],
            body: [
                "planTitle" : plan.planTitle,
                "deadline" : plan.deadline,
                "status" : plan.status.rawValue
            ]
        ) { [weak self] result in
            guard self != nil else { return }
            Logger.debug("result: \(result)")
            
            switch result {
            case .success(let (data, statusCode)):
                Logger.debug("Status Code: \(statusCode)")
                completion(data, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func deletePlan(id: Int, completion: @escaping (String?, String?) -> Void) {
        apiService.request(
            type: String.self,
            url: PlanningHelper.deleteTask(id: id).endpoint,
            method: .DELETE,
            header: ["Content-Type" : "application/json",
                     "Authorization" : "Bearer \(KeychainHelper.getString(key: .userID) ?? "")"],
            body: [ : ]
        ) { [weak self] result in
            guard self != nil else { return }
            Logger.debug("result: \(result)")
            
            switch result {
            case .success(let (data, statusCode)):
                Logger.debug("Status Code: \(statusCode)")
                completion(data, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
}
