//
//  AuthSessionAPIService.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 27.03.25.
//

import Foundation

final class AuthSessionAPIService: AuthSessionUseCase {
    
    private let apiService = CoreAPIManager.instance
    
    func createUser(user: RegisterDataModel, completion: @escaping (String?, String?) -> Void) {
        apiService.request(
            type: String.self,
            url: AuthSessionHelper.register.endpoint,
            method: .POST,
            header: ["Content-Type" : "application/json"],
            body: [
                "username" : (user.username ?? ""),
                "gender" : (user.gender?.rawValue ?? nil),
                "coupleName" : (user.coupleName ?? ""),
                "coupleGender" : (user.coupleGender?.rawValue ?? nil),
                "email": (user.email ?? ""),
                "password" : (user.password ?? ""),
                "bday" : (user.bday ?? nil),
                "auth" : (user.auth?.rawValue ?? "")
            ]
        ) { [weak self] result in
            guard self != nil else { return }
            Logger.debug("result: \(result)")
            
            switch result {
            case .success(let (data, statusCode)):
                Logger.debug("Status Code: \(statusCode)")
                if statusCode == 201 {
                    completion(data, nil)
                } else {
                    completion(nil, data)
                }
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func loginUser(user: LoginDataModel, completion: @escaping (String?, String?) -> Void) {
        apiService.request(
            type: String.self,
            url: AuthSessionHelper.login.endpoint,
            method: .POST,
            header: ["Content-Type" : "application/json"],
            body: [
                "email": user.email,
                "password" : user.password
            ]
        ) { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let (data, statusCode)):
                Logger.debug("User logged in successfully. Status Code: \(statusCode)")
                
                if (200...299).contains(statusCode) {
                    completion(data, nil)
                } else {
                    completion(nil, data)
                }
                
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func guestUserLogin(completion: @escaping (GuestLoginDataModel?, String?) -> Void) {
        apiService.request(
            type: GuestLoginDataModel.self,
            url: AuthSessionHelper.guestLogin.endpoint,
            method: .POST,
            header: ["Content-Type" : "application/json"],
            body: [ : ]
        ) { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let (data, statusCode)):
                Logger.debug("Guest user logged in successfully. Status Code: \(statusCode)")
                completion(data, nil)
                
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func googleSignIn(idToken: String, user: RegisterDataModel, completion: @escaping (String?, String?) -> Void) {
        apiService.request(
            type: String.self,
            url: AuthSessionHelper.googleLogin.endpoint,
            method: .POST,
            header: ["Content-Type" : "application/json",
                     "Authorization": "Bearer \(idToken)"],
            body: [
                "email": user.email ?? "",
                "name" : user.username ?? "",
                "gender" : user.gender?.rawValue ?? nil,
                "coupleName" : user.coupleName ?? "",
                "coupleGender" : user.coupleGender?.rawValue ?? nil,
                "bday" : user.bday ?? nil
            ]
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
    
    func googleEmailCheck(idToken: String, completion: @escaping (EmailOrTokenDataModel?, String?) -> Void) {
        apiService.request(
            type: EmailOrTokenDataModel.self,
            url: AuthSessionHelper.googleCheck.endpoint,
            method: .POST,
            header: ["Content-Type" : "application/json",
                     "Authorization": "Bearer \(idToken)"],
            body: [ : ]
        ) { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let (data, statusCode)):
                print(data)
                Logger.debug("Status Code: \(statusCode)")
                completion(data, nil)
                
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func appleCheck(idToken: String, user: RegisterDataModel, completion: @escaping (EmailOrTokenDataModel?, String?) -> Void) {
        apiService.request(
            type: EmailOrTokenDataModel.self,
            url: AuthSessionHelper.appleCheck.endpoint,
            method: .POST,
            header: ["Content-Type" : "application/json",
                     "Authorization": "Bearer \(idToken)"],
            body: [
                "username" : user.username ?? nil,
                "email": user.email ?? "",
                "auth": "APPLE"
            ]
        ) { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let (data, statusCode)):
                print(data)
                Logger.debug("Status Code: \(statusCode)")
                completion(data, nil)
                
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
}
