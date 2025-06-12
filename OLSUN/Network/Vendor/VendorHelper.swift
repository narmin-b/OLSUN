//
//  VendorHelper.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 03.06.25.
//

import Foundation

enum VendorHelper {
    case allVendorList
    case addClickCount
    
    var endpoint: URL? {
        switch self {
        case .allVendorList:
            return CoreAPIHelper.instance.makeURL(path: "vendor/all?lang=\(LocalizationManager.shared.currentLanguage)")
        case .addClickCount:
            return CoreAPIHelper.instance.makeURL(path: "vendor/clickcount")
        }
    }
}
