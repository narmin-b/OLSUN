//
//  CoreAPIHelper.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 27.03.25.
//

import Foundation

enum HttpMethods: String {
    case GET
    case POST
    case PATCH
    case PUT
    case DELETE
}

final class CoreAPIHelper {
    static let instance = CoreAPIHelper()
    private init() {}
    private let baseURL = "https://olsun.in/api/v1/"
    
    func makeURL(path: String) -> URL? {
        let urlString = baseURL + path
        return URL(string:urlString)
    }
    
    func makeAuthHeader(accessToken: String) -> [String: String] {
        return ["Authorization": "Bearer \(accessToken)"]
    }
}
