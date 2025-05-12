//
//  UserInfoDataModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 12.05.25.
//

import Foundation

struct UserInfoDataModel: Codable {
    var username: String
    var coupleName: String?
    var gender: Gender?
    var email: String?
    var bday: String?
}

struct ProfileInfoDisplayItem {
    let title: String
    let value: String
}

extension UserInfoDataModel {
    func toDisplayItems() -> [ProfileInfoDisplayItem] {
        return [
            ProfileInfoDisplayItem(title: OlsunStrings.nameText.localized, value: username),
            ProfileInfoDisplayItem(title: OlsunStrings.partnerNameText.localized, value: coupleName ?? "-"),
            ProfileInfoDisplayItem(title: OlsunStrings.gendertext.localized, value: gender?.rawValue.capitalized ?? "-"),
            ProfileInfoDisplayItem(title: OlsunStrings.emailText.localized, value: email ?? "-"),
            ProfileInfoDisplayItem(title: OlsunStrings.bdayText.localized, value: bday ?? "-")
        ]
    }
}
