//
//  PartnersNavigation.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 02.05.25.
//

protocol PartnersNavigation: AnyObject {
    func showPartnerDetail( newPartner: newPartner)
    func showPartnerGallery(partner: newPartner, selectedIndex: Int)
    func popController()
    func showProfile()
}
