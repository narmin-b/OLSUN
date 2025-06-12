//
//  VendorUseCase.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 03.06.25.
//

import Foundation

protocol VendorUseCase {
    func getAllVendorList(completion: @escaping([VendorDataModel]?, String?) -> Void)
    func addClickCount(dto: clickDataModel, completion: @escaping(String?, String?) -> Void)
}
