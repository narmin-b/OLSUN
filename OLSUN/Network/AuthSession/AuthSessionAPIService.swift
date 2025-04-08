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
                "username" : user.username,
                "gender" : user.gender.rawValue,
                "coupleName" : user.coupleName,
                "coupleGender" : user.coupleGender.rawValue,
                "email": user.email,
                "password" : user.password,
                "confirmPassword" : user.confirmPassword,
                "bday" : user.bday ?? "",
                "auth" : user.auth.rawValue
            ]
        ) { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let (data, statusCode)):
                print("User created successfully. Status Code: \(statusCode)")

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
    
//    func createUser(user: RegisterDataModel, completion: @escaping (String?, String?) -> Void) {
//        apiService.request(
//            type: String.self,
//            url: AuthSessionHelper.register.endpoint,
//            method: .POST,
//            header: ["Content-Type" : "application/json"],
//            body: [
//                "username" : user.username,
//                "gender" : user.gender.rawValue,
//                "coupleName" : user.coupleName,
//                "coupleGender" : user.coupleGender.rawValue,
//                "email": user.email,
//                "password" : user.password,
//                "confirmPassword" : user.confirmPassword,
//                "bday" : user.bday ?? "",
//                "auth" : user.auth.rawValue
//            ]
//        ) { [weak self] result in
//            guard let _ = self else { return }
//            switch result {
//            case .success(let data):
//                completion(data, nil)
//            case .failure(let error):
//                completion(nil, error.localizedDescription)
//            }
//        }
//    }
    
    func loginUser(user: RegisterDataModel, completion: @escaping (String?, String?) -> Void) {
        apiService.request(type: String.self,
                           url: AuthSessionHelper.login.endpoint,
                           method: .POST,
                           header: ["Content-Type" : "application/json"],
                           body: ["email": user.email, "password" : user.password]
        ) { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let (data, statusCode)):
                print("User created successfully. Status Code: \(statusCode)")

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
}
