//
//  LoginViewController.swift
//  CalendarApp
//
//  Created by Charmaine Andrea Legaspi on 1/29/23.
//

import UIKit
import FirebaseAuth
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var emailErrorMessageLabel: UILabel!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  let disposeBag = DisposeBag()
  
  var viewModel: LoginViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bindTextFields()
    bindLoginButton()
    bindLoadingHUD()
  }
}

// MARK: - Bind
extension LoginViewController {
  private func bindTextFields() {
    emailTextField.rx.text.orEmpty
      .bind(to: viewModel.email)
      .disposed(by: disposeBag)
    
    passwordTextField.rx.text.orEmpty
      .bind(to: viewModel.password)
      .disposed(by: disposeBag)
    
    emailTextField.rx
      .controlEvent([.editingChanged])
      .withLatestFrom(emailTextField.rx.text.orEmpty)
      .subscribe(onNext: { [unowned self] text in
        self.emailErrorMessageLabel.text = text.isValidEmail ? "" : "Invalid email."
      })
      .disposed(by: disposeBag)
  }
  
  private func bindLoginButton() {
    viewModel.isValidForm
      .bind(to: loginButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    loginButton.rx.tap
      .bind { [unowned self] in self.viewModel.login() }
      .disposed(by: disposeBag)
  }
  
  private func bindLoadingHUD() {
    viewModel.isLoading
      .subscribe(onNext: { [unowned self] isLoading in
        isLoading ? self.showProgress() : self.hideProgress()
      }).disposed(by: disposeBag)
    
    viewModel.errorMessage
      .subscribe(onNext: { [unowned self] errorMessage in
        self.showAlert(title: "", message: errorMessage)
      })
      .disposed(by: disposeBag)
  }
}
