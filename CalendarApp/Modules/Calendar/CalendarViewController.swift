//
//  ViewController.swift
//  CalendarApp
//
//  Created by Charmaine Andrea Legaspi on 1/29/23.
//

import UIKit
import CalendarKit
import EventKit

protocol CalendarViewControllerDelegate: NSObject {
  func presentDetailViewForEvent(_ event: EKEvent)
  func presentEditViewForEvent(_ event: EKEvent)
}

class CalendarViewController: DayViewController {
  var eventStore: EKEventStore!
  var calendarDelegate: CalendarViewControllerDelegate?
  
  // MARK: - Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .red
    requestAccessToCalendar()
    subscribeToNotification()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    title = "Calendar"
    navigationController?.setToolbarHidden(true, animated: false)
    navigationItem.setHidesBackButton(true, animated: false)
  }
  
  // MARK: - CalendarKit
  // Display calendar view
  override func eventsForDate(_ date: Date) -> [EventDescriptor] {
    let startDate = date
    var oneDayComponent = DateComponents()
    oneDayComponent.day = 1
    
    let endDate = calendar.date(byAdding: oneDayComponent,
                                to: startDate)!
    let predicate = eventStore.predicateForEvents(withStart: startDate,
                                                  end: endDate,
                                                  calendars: nil)
    let eventKitEvents = eventStore.events(matching: predicate)
    let calendarKitEvents = eventKitEvents.map(EKEventWrapper.init)
    return calendarKitEvents
  }
  
  // Did long press for creating event
  override func dayView(dayView: DayView, didLongPressTimelineAt date: Date) {
    endEventEditing()
    let newEKWrapper = createNewEvent(at: date)
    create(event: newEKWrapper, animated: true)
  }
  
  // Display event details
  override func dayViewDidSelectEventView(_ eventView: EventView) {
    guard let eventDescriptor = eventView.descriptor as? EKEventWrapper else {
      return
    }
    
    self.calendarDelegate?.presentDetailViewForEvent(eventDescriptor.ekEvent)
  }
  
  // Change event timeline
  override func dayViewDidLongPressEventView(_ eventView: EventView) {
    guard let descriptor = eventView.descriptor as? EKEventWrapper else {
      return
    }
    endEventEditing()
    beginEditing(event: descriptor)
  }
  
  override func dayViewDidBeginDragging(dayView: DayView) {
    endEventEditing()
  }
  
  // Edit existing and newly created events
  override func dayView(dayView: DayView, didUpdate event: EventDescriptor) {
    guard let editingEvent = event as? EKEventWrapper else {
      return
    }
    
    if let originalEvent = event.editedEvent {
      editingEvent.commitEditing()
      
      if originalEvent === editingEvent {
        self.calendarDelegate?.presentEditViewForEvent(editingEvent.ekEvent)
      } else {
        try! eventStore.save(editingEvent.ekEvent,
                             span: .thisEvent)
      }
    }
    
    reloadData()
  }
  
  override func dayView(dayView: DayView, didTapTimelineAt date: Date) {
    endEventEditing()
  }
}

extension CalendarViewController {
  private func requestAccessToCalendar() {
    eventStore.requestAccess(to: .event) { [weak self] granted, error in
      DispatchQueue.main.async {
        if let self = self {
          self.subscribeToNotification()
          self.reloadData()
        }
      }
    }
  }
  
  private func createNewEvent(at date: Date) -> EKEventWrapper {
    let newEKEvent = EKEvent(eventStore: eventStore)
    newEKEvent.calendar = eventStore.defaultCalendarForNewEvents

    var components = DateComponents()
    components.hour = 1
    let endDate = calendar.date(byAdding: components, to: date)
    
    newEKEvent.startDate = date
    newEKEvent.endDate = endDate
    newEKEvent.title = "New Event"
    
    let newEKWrapper = EKEventWrapper(eventKitEvent: newEKEvent)
    newEKWrapper.editedEvent = newEKWrapper
    return newEKWrapper
  }
  
  private func subscribeToNotification() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(storeChanged(_:)),
                                           name: .EKEventStoreChanged,
                                           object: eventStore)
  }
  
  @objc
  private func storeChanged(_ notification: Notification) {
    reloadData()
  }
}
