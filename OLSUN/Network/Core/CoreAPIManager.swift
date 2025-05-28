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
        completion: @escaping ((Result<(T, Int), CoreErrorModel>) -> Void)
    ) {
        guard let url = url else { return }
        Logger.debug("URL: \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = header
        
        if !body.isEmpty {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
        
            if let error = error {
                let code = (response as? HTTPURLResponse)?.statusCode ?? -1
                completion(.failure(CoreErrorModel(code: code, message: "İnternet bağlantısı yoxdur. Zəhmət olmasa bağlantınızı yoxlayın.")))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(CoreErrorModel.generalError()))
                return
            }
            
            Logger.debug("Response Status Code: \(httpResponse.statusCode)")
            
            
            guard let data = data, !data.isEmpty else {
                completion(.failure(CoreErrorModel(code: httpResponse.statusCode, message: "No data received")))
                return
            }
            
            if !(200..<300).contains(httpResponse.statusCode) {
                if let serverError = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                    let errorMessage = serverError.message ?? "Unknown error"
                    completion(.failure(CoreErrorModel(code: httpResponse.statusCode, message: errorMessage)))
                } else {
                    let rawMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                    completion(.failure(CoreErrorModel(code: httpResponse.statusCode, message: rawMessage)))
                }
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
        if T.self == String.self, let string = String(data: data, encoding: .utf8) as? T {
            completion(.success((string, statusCode)))
            return
        }

        do {
            let response = try JSONDecoder().decode(T.self, from: data)
            completion(.success((response, statusCode)))
        } catch {
            completion(.failure(CoreErrorModel(code: statusCode, message: "Decoding error: \(error.localizedDescription)")))
        }
    }
}
