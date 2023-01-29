//
//  FirebaseAuthManager.swift
//  CalendarApp
//
//  Created by Charmaine Andrea Legaspi on 1/29/23.
//

import FirebaseAuth

struct FirebaseAuthService {
  static func login(user: LoginModel, completionHandler: @escaping (Result<Bool, Error>) -> Void) {
    Auth.auth().signIn(withEmail: user.email, password: user.password) { (result, error) in
      if let error = error {
        completionHandler(.failure(error))
      } else {
        completionHandler(.success(true))
      }
    }
  }
}
