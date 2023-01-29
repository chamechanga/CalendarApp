//
//  LoginViewModel.swift
//  CalendarApp
//
//  Created by Charmaine Andrea Legaspi on 1/30/23.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
  private var model: LoginModel!
  
  let email = BehaviorRelay<String>(value: "")
  let password = BehaviorRelay<String>(value: "")
  
  let isLoading = BehaviorRelay<Bool>(value: false)
  let isSuccess = BehaviorRelay<Bool>(value: false)
  let errorMessage = PublishSubject<String>()
  
  var isValidForm: Observable<Bool> {
    return Observable.combineLatest(email, password) { email, password in
      return !email.isEmpty && !password.isEmpty && email.isValidEmail
    }
  }
  
  func login() {
    model = LoginModel(email: email.value, password: password.value)
    
    self.isLoading.accept(true)
    
    FirebaseAuthService.login(user: model) { [weak self] result in
      guard let self = self else { return }
      
      self.isLoading.accept(false)
      switch result {
      case .success(_):
        self.isSuccess.accept(true)
      case .failure(let error):
        self.isSuccess.accept(false)
        self.errorMessage.onNext(error.localizedDescription)
      }
    }
  }
}
