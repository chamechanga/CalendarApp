//
//  LoginCoordinator.swift
//  CalendarApp
//
//  Created by Charmaine Andrea Legaspi on 1/31/23.
//

import RxSwift
import UIKit

class LoginCoordinator: Coordinator {
  var childCoordinators = [Coordinator]()
  var navigationController: UINavigationController
  let disposeBag = DisposeBag()
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let viewController = LoginViewController()
    let viewModel = LoginViewModel()
    viewController.viewModel = viewModel
    
    viewModel.isSuccess.asObservable()
      .bind { [weak self] value in
        guard let self = self else { return }
        if value {
          self.coordinateWithCalendar()
        }
      }.disposed(by: disposeBag)
    
    navigationController.pushViewController(viewController, animated: true)
  }
  
  private func coordinateWithCalendar() {
    let calendarCoordinator = CalendarCoordinator(navigationController: navigationController)
    calendarCoordinator.start()
  }
}
