//
//  PlanningUseCase.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 16.04.25.
//

import Foundation

protocol PlanningUseCase {
    func addPlan(plan: PlanDataModel, completion: @escaping(String?, String?) -> Void)
    func getPlanList(completion: @escaping([PlanDataModel]?, String?) -> Void)
    func editPlan(plan: PlanDataModel, completion: @escaping(String?, String?) -> Void)
    func deletePlan(id: Int, completion: @escaping(String?, String?) -> Void)
}
