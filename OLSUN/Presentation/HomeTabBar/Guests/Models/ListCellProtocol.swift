//
//  ListCellProtocol.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 15.04.25.
//

import Foundation

enum EditStatus: String, Codable {
    case accepted = "ACCEPTED"
    case invited = "INVITED"
    case declined = "DECLINED"
}

struct ListCellProtocol {
    var titleString: String
    var dateString: String
    var statusString: EditStatus
    var idInt: Int
}
