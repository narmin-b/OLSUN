//
//  AppleHelper.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 13.05.25.
//

import Foundation
import AuthenticationServices

struct AppleUser {
    let name: String?
    let email: String?
    let userIdentifier: String
    let identityToken: String
}

final class AppleAuthManager: NSObject {

    static let shared = AppleAuthManager()
    private var completionHandler: ((Result<SingInUser, Error>) -> Void)?

    private override init() {}

    func signIn(completion: @escaping (Result<SingInUser, Error>) -> Void) {
        self.completionHandler = completion

        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension AppleAuthManager: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let identityTokenData = appleIDCredential.identityToken,
              let identityToken = String(data: identityTokenData, encoding: .utf8) else {
            let error = NSError(domain: "AppleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve identity token"])
            completionHandler?(.failure(error))
            return
        }

//        let user = SingInUser(
//            name:   [appleIDCredential.fullName?.givenName, appleIDCredential.fullName?.familyName]
//                    .compactMap { $0 }
//                .joined(separator: " ").nilIfEmpty ?? "",
//            email: appleIDCredential.email ?? "",
//            idToken: identityToken,
//            appleID: appleIDCredential.user
//        )
        
        let fullName = [appleIDCredential.fullName?.givenName, appleIDCredential.fullName?.familyName]
                        .compactMap { $0 }
                        .joined(separator: " ").nilIfEmpty

        let user = SingInUser(
            name: fullName,
            email: appleIDCredential.email,
            idToken: identityToken,
            appleID: appleIDCredential.user
        )

        print(user)
        completionHandler?(.success(user))
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        completionHandler?(.failure(error))
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension AppleAuthManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}

// MARK: - Helper

private extension String {
    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }
}
