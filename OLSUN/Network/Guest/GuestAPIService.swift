//
//  GuestAPIService.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 15.04.25.
//

import Foundation

final class GuestAPIService: GuestUseCase {
    
    private let apiService = CoreAPIManager.instance
    
    func addGuest(guest: GuestDataModel, completion: @escaping (String?, String?) -> Void) {
        apiService.request(
            type: String.self,
            url: GuestHelper.addGuest.endpoint,
            method: .POST,
            header: ["Content-Type" : "application/json",
                     "Authorization" : "Bearer \(KeychainHelper.getString(key: .userID) ?? "")"],
            body: [
                "name" : guest.name,
                "guestInvitationDate" : guest.guestInvitationDate,
                "guestStatus" : guest.guestStatus.rawValue
                
            ]
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
    
    func getGuestList(completion: @escaping ([GuestDataModel]?, String?) -> Void) {
        apiService.request(
            type: [GuestDataModel].self,
            url: GuestHelper.allGuestList.endpoint,
            method: .GET,
            header: ["Content-Type" : "application/json",
                     "Authorization" : "Bearer \(KeychainHelper.getString(key: .userID) ?? "")"],
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
    
    func editGuest(guest: GuestDataModel, completion: @escaping (String?, String?) -> Void) {
        apiService.request(
            type: String.self,
            url: GuestHelper.editGuest(id: guest.id!).endpoint,
            method: .PUT,
            header: ["Content-Type" : "application/json",
                     "Authorization" : "Bearer \(KeychainHelper.getString(key: .userID) ?? "")"],
            body: [
                "name" : guest.name,
                "guestInvitationDate" : guest.guestInvitationDate,
                "guestStatus" : guest.guestStatus.rawValue
            ]
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
    
    func deleteGuest(id: Int, completion: @escaping (String?, String?) -> Void) {
        apiService.request(
            type: String.self,
            url: GuestHelper.deleteGuest(id: id).endpoint,
            method: .DELETE,
            header: ["Content-Type" : "application/json",
                     "Authorization" : "Bearer \(KeychainHelper.getString(key: .userID) ?? "")"],
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
}
