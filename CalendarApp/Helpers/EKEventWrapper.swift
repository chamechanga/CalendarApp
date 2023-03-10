//
//  File.swift
//  CalendarApp
//
//  Created by Charmaine Andrea Legaspi on 1/30/23.
//

import UIKit
import CalendarKit
import EventKit

final class EKEventWrapper: EventDescriptor {
  public var dateInterval: DateInterval {
      get {
          DateInterval(start: ekEvent.startDate, end: ekEvent.endDate)
      }
      
      set {
          ekEvent.startDate = newValue.start
          ekEvent.endDate = newValue.end
      }
  }
  
  public var isAllDay: Bool {
      get {
          ekEvent.isAllDay
      }
      set {
          ekEvent.isAllDay = newValue
      }
  }
  
  public var text: String {
      get {
          ekEvent.title
      }
      
      set {
          ekEvent.title = newValue
      }
  }

  public var attributedText: NSAttributedString?
  public var lineBreakMode: NSLineBreakMode?
  
  public var color: UIColor {
      get {
          UIColor(cgColor: ekEvent.calendar.cgColor)
      }
  }
  
  public var backgroundColor = UIColor()
  public var textColor = SystemColors.label
  public var font = UIFont.boldSystemFont(ofSize: 12)
  public weak var editedEvent: EventDescriptor? {
    didSet {
      updateColors()
    }
}
  
  public private(set) var ekEvent: EKEvent
  
  public init(eventKitEvent: EKEvent) {
      self.ekEvent = eventKitEvent
    applyStandardColors()
  }
  
  public func makeEditable() -> Self {
      let cloned = Self(eventKitEvent: ekEvent)
      cloned.editedEvent = self
      return cloned
  }
  
  public func commitEditing() {
      guard let edited = editedEvent else {return}
      edited.dateInterval = dateInterval
  }
  
  func updateColors() {
    (editedEvent != nil) ? applyEditingColors() : applyStandardColors()
  }
  
  private func applyStandardColors() {
    backgroundColor = .black
    textColor = .white
  }
  
  private func applyEditingColors() {
    backgroundColor = .systemPink
    textColor = .white
  }
}
