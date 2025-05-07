//
//  LocalizationManager.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 08.05.25.
//

import Foundation

class LocalizationManager {
    static let shared = LocalizationManager()

    private var bundle: Bundle?

    private init() {
        loadBundle(for: currentLanguage)
    }

    var currentLanguage: String {
        UserDefaultsHelper.getString(key: .appLanguage) ?? Locale.preferredLanguages.first ?? "en"
    }

    func setLanguage(_ language: String) {
        UserDefaultsHelper.setString(key: .appLanguage, value: language)
        loadBundle(for: language)
    }

    private func loadBundle(for language: String) {
        if let path = Bundle.main.path(forResource: language, ofType: "lproj") {
            bundle = Bundle(path: path)
        } else {
            bundle = Bundle.main
        }
    }

    func localizedString(forKey key: String) -> String {
        bundle?.localizedString(forKey: key, value: nil, table: nil) ?? key
    }
}
