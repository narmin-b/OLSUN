//
//  VendorDto.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 03.06.25.
//

import Foundation

// MARK: - VendorDto
struct VendorDataModel: Codable {
    let id: Int
    let name, description: String
    let isBusinessOwner: Bool
    let vendorCategory, categoryDisplayName: String
    let galleryUrls: [String]
    let titleImageURL: String
    let socialMediaAccounts: [SocialMediaAccount]
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, description, isBusinessOwner, vendorCategory, categoryDisplayName, galleryUrls
        case titleImageURL = "titleImageUrl"
        case socialMediaAccounts, createdAt
    }
}

// MARK: - SocialMediaAccount
struct SocialMediaAccount: Codable {
    let id: Int?
    let platformName, link: String
}

typealias VendorList = [VendorDataModel]

struct newPartner {
    let id: Int?
    let name: String
    let description: String?
    let coverImage: String
    let category: ServiceType?
    let categoryDisplayName: String
    let gallery: [String]
    let contact: [SocialMediaAccount]
}

extension VendorDataModel {
    func mapToDomain() -> newPartner {
        .init(
            id: id,
            name: name,
            description: description,
            coverImage: titleImageURL,
            category: ServiceType(rawValue: vendorCategory) ?? .barber,
            categoryDisplayName: categoryDisplayName,
            gallery: galleryUrls,
            contact: socialMediaAccounts
        )
    }
}

struct clickDataModel {
    let vendorId: Int
    let platformId: String
}

//if let serviceType = ServiceType(rawValue: vendorDataModel.vendorCategory) {
//    let partner = newPartner(
//        name: vendorDataModel.name,
//        description: vendorDataModel.description,
//        coverImage: vendorDataModel.titleImageURL,
//        category: serviceType,
//        categoryDisplayName: vendorDataModel.categoryDisplayName,
//        gallery: vendorDataModel.galleryUrls,
//        contact: vendorDataModel.socialMediaAccounts
//    )
//} else {
//    // Handle case where the string doesn't match any enum case
//    print("Invalid vendor category: \(vendorDataModel.vendorCategory)")
//}

//struct VendorCellProtocol {
//    var titleString: String
//    var dateString: String
//    var statusString: EditStatus
//    var idInt: Int
//}
