//
//  GuestDataModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 15.04.25.
//

struct GuestDataModel: Codable {
    let id: Int?
    let name: String
    let guestInvitationDate: String
    let guestStatus: EditStatus
}

extension GuestDataModel {
    func mapToDomain() -> ListCellProtocol {
        .init(
            titleString: name,
            dateString: guestInvitationDate,
            statusString: guestStatus,
            idInt: id ?? 0
        )
    }
}
