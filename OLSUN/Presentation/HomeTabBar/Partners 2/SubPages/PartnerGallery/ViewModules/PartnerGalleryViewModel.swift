//
//  PartnerGalleryViewModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 03.05.25.
//

import Foundation

struct MediaItem {
    let url: String
    let isVideo: Bool

    init(url: String) {
        self.url = url
        self.isVideo = MediaItem.isVideoURL(url)
    }

    private static func isVideoURL(_ url: String) -> Bool {
        let videoExtensions = ["mp4", "mov", "avi", "m4v"]
        guard let fileExtension = URL(string: url)?.pathExtension.lowercased() else {
            return false
        }
        return videoExtensions.contains(fileExtension)
    }
}

extension MediaItem {
    var urlWithBase: String {
        return url.hasPrefix("http") ? url : "https://olsun.in\(url)"
    }
}

final class PartnerGalleryViewModel {
    enum ViewState {
        case loading
        case loaded
        case success
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
    private weak var navigation: PartnersNavigation?
    var partner: newPartner?
    var selectedIndex: Int
    
    var limitedGallery: [MediaItem] {
        return Array(partner?.gallery.prefix(3).map { MediaItem(url: $0) } ?? [])
    }
    
    init(navigation: PartnersNavigation, partner: newPartner, selectedIndex: Int) {
        self.navigation = navigation
        self.partner = partner
        self.selectedIndex = selectedIndex
    }
    
    func popBackController() {
        navigation?.popController()
    }
}
