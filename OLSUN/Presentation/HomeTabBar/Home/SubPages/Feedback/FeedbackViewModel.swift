import Foundation

final class FeedbackViewModel {
    enum ViewState {
        case loading
        case loaded
        case success
        case error(message: String)
    }
    
    var requestCallback: ((ViewState) -> Void)?
    
    func sendFeedback(text: String) {
        guard let authId = KeychainHelper.getString(key: .userID) else {
            requestCallback?(.error(message: "Auth ID tapılmadı"))
            return
        }
        requestCallback?(.loading)
        FeedbackAPIService.shared.sendFeedback(text: text, authId: authId) { [weak self] success, error in
            DispatchQueue.main.async {
                self?.requestCallback?(.loaded)
                if success {
                    self?.requestCallback?(.success)
                } else {
                    self?.requestCallback?(.error(message: error ?? "Bilinməyən xəta"))
                }
            }
        }
    }
} 