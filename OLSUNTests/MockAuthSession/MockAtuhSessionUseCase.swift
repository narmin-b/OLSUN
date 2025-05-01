//
//  MockAtuhSessionUseCase.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 30.04.25.
//

import XCTest
@testable import OLSUN

class MockAuthSessionUseCase: AuthSessionUseCase {
    var loginCalled = false
    var signUpCalled = false
    var googleCheckCalled = false
    var shouldSucceed = true
    var shouldReturnEmailStatus = false
    
    func loginUser(user: LoginDataModel, completion: @escaping (String?, String?) -> Void) {
        loginCalled = true
        if shouldSucceed {
            completion("mock_user_id", nil)
        } else {
            completion(nil, "Invalid credentials")
        }
    }
    
    func googleEmailCheck(idToken: String, completion: @escaping (EmailOrTokenDataModel?, String?) -> Void) {
        googleCheckCalled = true
        if shouldSucceed {
            if shouldReturnEmailStatus {
                completion(EmailOrTokenDataModel(status: .email, message: "email confirmed"), nil)
            } else {
                completion(nil, "Google login found.")
            }
        } else {
            completion(nil, "Google login requires email input.")
        }
    }

    func createUser(user: RegisterDataModel, completion: @escaping (String?, String?) -> Void) {
        
    }
    
    func googleSignIn(idToken: String, user: RegisterDataModel, completion: @escaping (String?, String?) -> Void) {

    }
}
