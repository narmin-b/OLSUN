//
//  AuthSessionUseCake.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 27.03.25.
//

import Foundation

protocol AuthSessionUseCase {
    func createUser(user: RegisterDataModel, completion: @escaping(String?, String?) -> Void)
    func loginUser(user: LoginDataModel, completion: @escaping(String?, String?) -> Void)
}
