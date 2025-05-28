//
//  AccountSessionUseCase.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 11.05.25.
//

import Foundation

protocol AccountSessionUseCase {
    func deleteAccount(completion: @escaping(String?, String?) -> Void)
    func getUserInfo(completion: @escaping(UserInfoDataModel?, String?) -> Void)
}
