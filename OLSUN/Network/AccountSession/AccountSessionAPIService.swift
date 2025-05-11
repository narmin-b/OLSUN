//
//  AccountSessionAPIService.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 11.05.25.
//

import Foundation

final class AccountSessionAPIService: AccountSessionUseCase {
    
    private let apiService = CoreAPIManager.instance
    
    
    func deleteAccount(completion: @escaping (String?, String?) -> Void) {
        apiService.request(
            type: String.self,
            url: AccountSessionHelper.deleteAccount.endpoint,
            method: .DELETE,
            header: ["Content-Type" : "application/json",
                     "Authorization": "Bearer \(KeychainHelper.getString(key: .userID) ?? "")"],
            body: [ : ]
        ) { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let (data, statusCode)):
                Logger.debug("Status Code: \(statusCode)")
                completion(data, nil)
                
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
}
