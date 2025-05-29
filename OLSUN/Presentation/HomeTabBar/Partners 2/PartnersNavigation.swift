//
//  PartnersNavigation.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 02.05.25.
//

protocol PartnersNavigation: AnyObject {
    func showPartnerDetail(partner: Partner)
    func showPartnerGallery(partner: Partner, selectedIndex: Int)
    func popController()
    func showProfile()
}
