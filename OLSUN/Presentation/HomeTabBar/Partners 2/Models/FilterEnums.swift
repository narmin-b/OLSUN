//
//  FilterEnums.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 02.05.25.
//

import Foundation

enum ServiceLocation: String, CaseIterable {
    case baku 
    
    var localizedName: String {
        switch self {
        case .baku:
            return OlsunStrings.bakuText.localized
        }
    }
    
    static func fromLocalizedName(_ name: String) -> ServiceLocation? {
        return self.allCases.first { $0.localizedName == name }
    }
}

enum ServiceType: String, CaseIterable {
    case weddingDresses = "GELINLIKLAR"
    case tuxedo = "BAYLIK_KOSTYUMLARI"
    case photographer = "FOTOQRAF"
    case khonca = "XONCA"
    case khinaOrg = "XINAYAXDI"
    case decoration = "DEKORASIYA"
    case sweets = "SIRNIYYATLAR"
    case barber = "GOZELLIK_SALONLARI"
    
    var localizedName: String {
        switch self {
        case .weddingDresses:
            return OlsunStrings.weddingDressText.localized
        case .tuxedo:
            return OlsunStrings.tuxedoText.localized
        case .photographer:
            return OlsunStrings.photographerText.localized
        case .khonca:
            return OlsunStrings.khoncaText.localized
        case .khinaOrg:
            return OlsunStrings.khinaOrgText.localized
        case .decoration:
            return OlsunStrings.decorationText.localized
        case .sweets:
            return OlsunStrings.sweetsText.localized
        case .barber:
            return OlsunStrings.beautySalonText.localized
        }
    }
    
    static func fromLocalizedName(_ name: String) -> ServiceType? {
        return self.allCases.first { $0.localizedName == name }
    }
}
