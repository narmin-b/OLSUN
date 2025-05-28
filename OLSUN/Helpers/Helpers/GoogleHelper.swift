//
//  GoogleHelper.swift
//  OLSUN
//
//  Created by Narmin Baghirova on 12.04.25.
//

import GoogleSignIn

struct SingInUser {
    let name: String?
    let email: String?
    let idToken: String?
    let appleID: String?
}

final class GoogleAuthManager {

    static let shared = GoogleAuthManager()
    private init() {}

    func signIn(from viewController: UIViewController, completion: @escaping (Result<SingInUser, Error>) -> Void) {
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                let error = NSError(domain: "GoogleSignIn", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing ID Token"])
                completion(.failure(error))
                return
            }

            let googleUser = SingInUser(
                name: user.profile?.name ?? "Unknown",
                email: user.profile?.email ?? "No email",
                idToken: idToken,
                appleID: nil
            )

            completion(.success(googleUser))
        }
    }
}
