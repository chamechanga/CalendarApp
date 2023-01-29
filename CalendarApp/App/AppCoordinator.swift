//
//  AppCoordinator.swift
//  CalendarApp
//
//  Created by Charmaine Andrea Legaspi on 1/30/23.
//

import RxSwift
import UIKit

protocol Coordinator {
  var childCoordinators: [Coordinator] { get set }
  var navigationController: UINavigationController { get set }
  func start()
}

class AppCoordinator: Coordinator {
  var childCoordinators = [Coordinator]()
  var navigationController: UINavigationController
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let loginCoordinator = LoginCoordinator(navigationController: navigationController)
    childCoordinators.append(loginCoordinator)
    loginCoordinator.start()
  }
}
