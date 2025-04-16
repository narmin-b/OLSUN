//
//  PlanDataModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 16.04.25.
//

struct PlanDataModel: Codable {
    let id: Int?
    let planTitle: String
    let deadline: String
    let status: EditStatus
}

extension PlanDataModel {
    func mapToDomain() -> ListCellProtocol {
        .init(
            titleString: planTitle,
            dateString: deadline,
            statusString: status,
            idInt: id ?? 0
        )
    }
}
