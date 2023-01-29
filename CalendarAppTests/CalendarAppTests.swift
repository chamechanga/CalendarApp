//
//  CalendarAppTests.swift
//  CalendarAppTests
//
//  Created by Charmaine Andrea Legaspi on 1/29/23.
//

import XCTest
import FirebaseAuth
import RxSwift
import RxTest
import RxCocoa
import RxBlocking
@testable import CalendarApp

class CalendarAppTests: XCTestCase {
  var viewModel: LoginViewModel!
  var disposeBag: DisposeBag!
  
  override func setUp() {
    super.setUp()
    
    viewModel = LoginViewModel()
    disposeBag = DisposeBag()
  }
  
  override func tearDown() {
    super.tearDown()
    
    viewModel = nil
    disposeBag = nil
  }
  
  func testIsValidForm() {
    let model = LoginModel(email: "hello@gmail.com", password: "hello")
    
    self.viewModel.email.accept(model.email)
    self.viewModel.password.accept(model.password)
    
    viewModel.isValidForm
      .subscribe(onNext: {
        XCTAssertTrue($0)
      })
      .disposed(by: disposeBag)
  }
  
  func testLoginErrorMessage() throws {
    let expectation = expectation(description: "Show login error message")
    
    let loginModel = LoginModel(email: "hello@gmail.com", password: "hello")
    self.viewModel.email.accept(loginModel.email)
    self.viewModel.password.accept(loginModel.password)
    self.viewModel.login()
    
    self.viewModel.errorMessage.subscribe(onNext: { errorMessage in
      XCTAssertNotNil(errorMessage)
      expectation.fulfill()
    }).disposed(by: disposeBag)
    
    wait(for: [expectation], timeout: 10.0)
  }
  
  func testLoginFail() throws {
    let scheduler = TestScheduler(initialClock: 0)
    let isSuccessObserver = scheduler.createObserver(Bool.self)
    
    let loginModel = LoginModel(email: "hello@gmail.com", password: "hello")
    self.viewModel.email.accept(loginModel.email)
    self.viewModel.password.accept(loginModel.password)
    
    viewModel.isSuccess
      .bind(to: isSuccessObserver)
      .disposed(by: disposeBag)
    
    scheduler.scheduleAt(10) {
      self.viewModel.login()
    }
    
    scheduler.start()
    
    let result = try viewModel.isSuccess.take(2).toBlocking().toArray()
    
    XCTAssertEqual(result.last, false)
  }
}
