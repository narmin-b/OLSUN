//
//  VendorAPIService.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 03.06.25.
//

import Foundation

final class VendorAPIService: VendorUseCase {
    
    private let apiService = CoreAPIManager.instance
    
    func getAllVendorList(completion: @escaping ([VendorDataModel]?, String?) -> Void) {
        apiService.request(
            type: [VendorDataModel].self,
            url: VendorHelper.allVendorList.endpoint,
            method: .GET,
            header: ["Content-Type" : "application/json"],
            body: [ : ]
        ) { [weak self] result in
            guard self != nil else { return }
            Logger.debug("result: \(result)")
            
            switch result {
            case .success(let (data, statusCode)):
                Logger.debug("Status Code: \(statusCode)")
                completion(data, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func addClickCount(dto: clickDataModel, completion: @escaping (String?, String?) -> Void) {
        apiService.request(
            type: String.self,
            url: VendorHelper.addClickCount.endpoint,
            method: .POST,
            header: ["Content-Type" : "application/json",
                     "Authorization" : "Bearer \(KeychainHelper.getString(key: .userID) ?? "")"],
            body: [
                "vendorId": dto.vendorId,
                "platformName": dto.platformId
            ]
        ) { [weak self] result in
            guard self != nil else { return }
            Logger.debug("result: \(result)")
            print("VENDOR INFO: \(dto.vendorId) ||||||| Plt: \(dto.platformId)")
            switch result {
            case .success(let (data, statusCode)):
                Logger.debug("Status Code: \(statusCode)")
                print("Status Code: \(statusCode) DATAAAA: \(data)")
                completion(data, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
}
