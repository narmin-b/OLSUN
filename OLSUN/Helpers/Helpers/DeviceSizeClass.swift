//
//  DeviceSizeClass.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 08.04.25.
//

import UIKit

enum DeviceSizeClass {
    case compact
    case standard
    case large
    case iPad

    static var current: DeviceSizeClass {
        let width = UIScreen.main.bounds.width
        let idiom = UIDevice.current.userInterfaceIdiom

        if idiom == .pad {
            return .iPad
        }

        switch width {
        case ..<376:
            return .compact
        case 376..<415:
            return .standard
        default:
            return .large
        }
    }
}
