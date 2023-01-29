//
//  CalendarCoordinator.swift
//  CalendarApp
//
//  Created by Charmaine Andrea Legaspi on 1/31/23.
//

import Foundation
import RxSwift
import UIKit
import EventKitUI

class CalendarCoordinator: NSObject, Coordinator {
  var childCoordinators = [Coordinator]()
  var navigationController: UINavigationController
  
  private let eventStore = EKEventStore()
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let viewController = CalendarViewController()
    viewController.eventStore = eventStore
    viewController.calendarDelegate = self
    navigationController.pushViewController(viewController, animated: true)
  }
}

extension CalendarCoordinator: CalendarViewControllerDelegate {
  func presentDetailViewForEvent(_ event: EKEvent) {
      let eventController = EKEventViewController()
      eventController.event = event
      eventController.allowsCalendarPreview = true
      eventController.allowsEditing = true
      navigationController.pushViewController(eventController, animated: true)
  }
  
  func presentEditViewForEvent(_ event: EKEvent) {
      let editEventViewController = EKEventEditViewController()
      editEventViewController.event = event
      editEventViewController.eventStore = eventStore
      editEventViewController.editViewDelegate = self
      navigationController.present(editEventViewController, animated: true)
  }
}

extension CalendarCoordinator: EKEventEditViewDelegate {
  func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
    navigationController.dismiss(animated: true)
  }
}

