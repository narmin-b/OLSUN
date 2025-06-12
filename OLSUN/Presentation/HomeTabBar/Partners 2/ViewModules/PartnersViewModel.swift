//
//  PartnersViewModel.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 02.05.25.
//

import Foundation

final class PartnersViewModel {
    enum ViewState {
        case loading
        case loaded
        case success
        case error(message: String)
    }
    
    var requestCallback : ((ViewState) -> Void?)?
    private weak var navigation: PartnersNavigation?
    private var vendorUseCase: VendorUseCase
    var protocolList: [newPartner] = []
    var allProtocolList: [newPartner] = []
    
    init(navigation: PartnersNavigation, vendorUseCase: VendorUseCase) {
        self.navigation = navigation
        self.vendorUseCase = vendorUseCase
    }
    
    // MARK: Navigations
    func showPartnerDetailVC(newPartner: newPartner) {
        navigation?.showPartnerDetail(newPartner: newPartner)
    }
    
    func showProfileScreen() {
        navigation?.showProfile()
    }
    
    func getAllVendorList() {
        requestCallback?(.loading)
        vendorUseCase.getAllVendorList { [weak self] result, error in
            guard let self = self else { return }
            self.requestCallback?(.loaded)
            DispatchQueue.main.async {
                if let result = result {
                    self.protocolList = (result.map({$0.mapToDomain()}))
                    self.allProtocolList = self.protocolList
                    print(self.protocolList)
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
    
    func refreshAllVendorList() {
        vendorUseCase.getAllVendorList { [weak self] result, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let result = result {
                    self.protocolList = (result.map({$0.mapToDomain()}))
                    self.allProtocolList = self.protocolList
                    print(self.protocolList)
                    self.requestCallback?(.success)
                } else if let error = error {
                    self.requestCallback?(.error(message: error))
                }
            }
        }
    }
}
