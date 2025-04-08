//
//  CoreAPIManager.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 27.03.25.
//

import Foundation

final class CoreAPIManager {
    static let instance = CoreAPIManager()
    private init() {}
    
    func request<T: Decodable>(
        type: T.Type,
        url: URL?,
        method: HttpMethods,
        header: [String: String] = [:],
        body: [String: Any] = [:],
        completion: @escaping ((Result<(T, Int), CoreErrorModel>) -> Void) // Now returns (data, statusCode)
    ) {
        guard let url = url else { return }
        print("URL:", url)
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = header
        
        if !body.isEmpty {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(CoreErrorModel.generalError()))
                return
            }
            
            print("Response Status Code:", httpResponse.statusCode)
            
            if httpResponse.statusCode == 401 {
                completion(.failure(CoreErrorModel.authError(code: httpResponse.statusCode)))
                return
            }
            
            if let error = error {
                completion(.failure(CoreErrorModel(code: httpResponse.statusCode, message: error.localizedDescription)))
                return
            }
            
            guard let data = data, !data.isEmpty else {
                completion(.failure(CoreErrorModel(code: httpResponse.statusCode, message: "No data received")))
                return
            }
            
            if T.self == Int.self {
                completion(.success((httpResponse.statusCode as! T, httpResponse.statusCode)))
                return
            }
            
            if T.self == String.self, let responseString = String(data: data, encoding: .utf8) {
                completion(.success((responseString as! T, httpResponse.statusCode)))
                return
            }
            
            self.handleResponse(data: data, statusCode: httpResponse.statusCode, completion: completion)
        }
        task.resume()
    }

    fileprivate func handleResponse<T: Decodable>(
        data: Data,
        statusCode: Int,
        completion: @escaping((Result<(T, Int), CoreErrorModel>) -> Void)
    ) {
        do {
            let response = try JSONDecoder().decode(T.self, from: data)
            completion(.success((response, statusCode)))
        } catch {
            completion(.failure(CoreErrorModel(code: statusCode, message: "Decoding error: \(error.localizedDescription)")))
        }
    }
//    func request<T: Decodable>(
//        type: T.Type,
//        url: URL?,
//        method: HttpMethods,
//        header: [String: String] = [:],
//        body: [String: Any] = [:],
//        completion: @escaping ((Result<T, CoreErrorModel>) -> Void)
//    ) {
//        guard let url = url else { return }
//        print("URL:", url)
//        
//        var request = URLRequest(url: url)
//        var finalHeaders = header
//        
//        if !finalHeaders.isEmpty {
//            request.allHTTPHeaderFields = finalHeaders
//        }
//        
//        request.httpMethod = method.rawValue
//        if !body.isEmpty {
//            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
//        }
//        
//        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
//            guard let self = self else { return }
//            guard let httpResponse = response as? HTTPURLResponse else {
//                completion(.failure(CoreErrorModel.generalError()))
//                return
//            }
//            
//            print("Response Status Code:", httpResponse.statusCode)
//            
//            if httpResponse.statusCode == 401 {
//                completion(.failure(CoreErrorModel.authError(code: httpResponse.statusCode)))
//                return
//            }
//            
//            if T.self == Int.self {
//                completion(.success(httpResponse.statusCode as! T))
//                return
//            }
//            
//            if let error = error {
//                completion(.failure(CoreErrorModel(code: httpResponse.statusCode, message: error.localizedDescription)))
//                return
//            }
//            
//            guard let data = data, !data.isEmpty else {
//                completion(.failure(CoreErrorModel.decodingError()))
//                return
//            }
//            
//            if T.self == String.self, let responseString = String(data: data, encoding: .utf8) {
//                completion(.success(responseString as! T))
//                return
//            }
//            
//            self.handleResponse(data: data, completion: completion)
//        }
//        task.resume()
//    }
//    
//    fileprivate func handleResponse<T: Decodable>(
//        data: Data,
//        completion: @escaping((Result<T,CoreErrorModel>) -> Void)
//    ) {
//        do {
//            let response = try JSONDecoder().decode(T.self, from: data)
//            completion(.success(response))
//        }
//        catch {
//            completion(.failure(CoreErrorModel.decodingError()))
//        }
//    }
}

struct EmptyResponse: Decodable {}
