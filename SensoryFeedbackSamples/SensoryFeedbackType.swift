import SwiftUI
//#if os(watchOS)
import RegexBuilder
//#endif

enum SensoryFeedbackType: String, CaseIterable, Identifiable, Hashable {
  case success, warning, error
  case selection
#if os(watchOS)
  case increase, decrease,
       softImpact, rigidImpact, solidImpact,
       lightImpact, mediumImpact, heavyImpact
#else
  case increase = "increase*"
  case decrease = "decrease*"
#endif
  case start
  case stop
  case alignment
  case levelChange
#if !os(watchOS)
  case softImpact = "impact(flexibility: .soft)"
  case rigidImpact = "impact(flexibility: .rigid)"
  case solidImpact = "impact(flexibility: .solid)"
  case lightImpact = "impact(weight: .light)"
  case mediumImpact = "impact(weight: .medium)"
  case heavyImpact = "impact(weight: .heavy)"
#endif

  var id: String { rawValue }

  var title: String {
#if os(watchOS)
    rawValue
#else
    ".\(rawValue)"
#endif
  }

  var sensoryFeedback: SensoryFeedback {
    switch self {
    case .success: .success
    case .warning: .warning
    case .error: .error
    case .selection: .selection
    case .increase: .increase
    case .decrease: .decrease
    case .start: .start
    case .stop: .stop
    case .alignment: .alignment
    case .levelChange: .levelChange
    case .softImpact: .impact(flexibility: .soft)
    case .rigidImpact: .impact(flexibility: .rigid)
    case .solidImpact: .impact(flexibility: .solid)
    case .lightImpact: .impact(weight: .light)
    case .mediumImpact: .impact(weight: .medium)
    case .heavyImpact: .impact(weight: .heavy)
    }
  }

  enum Platform: String, CaseIterable {
    case iphone = "iphone"
    case watch = "applewatch"
    case macos = "macbook"
  }

  var platforms: [Platform] {
    switch self {
    case .success, .warning, .error,
        .selection,
        .softImpact, .rigidImpact, .solidImpact,
        .lightImpact, .mediumImpact, .heavyImpact: [.iphone, .watch]
    case .increase, .decrease, .start, .stop: [.watch]
    case .alignment, .levelChange: [.macos]
    }
  }
}
