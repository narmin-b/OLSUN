import Foundation

struct FeedbackResponse: Codable {
    let message: String
}

final class FeedbackAPIService {
    static let shared = FeedbackAPIService()
    private let apiService = CoreAPIManager.instance
    
    func sendFeedback(text: String, authId: String, completion: @escaping (Bool, String?) -> Void) {
        guard let url = CoreAPIHelper.instance.makeURL(path: "feedback/create") else { return }
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(authId)"
        ]
        let body: [String: String] = ["text": text]
        print("auth:", authId)
        print("url", url)
        apiService.request(
            type: FeedbackResponse.self,
            url: url,
            method: .POST,
            header: headers,
            body: body
        ) { result in
            switch result {
            case .success(let (data, statusCode)):
                print("Feedback API response: \(data.message)")
                completion(statusCode == 200, data.message)
            case .failure(let error):
                print("Feedback API error: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
            }
        }
    }
} 
