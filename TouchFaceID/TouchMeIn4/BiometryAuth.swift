/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import LocalAuthentication

struct BiometryAuth {

  enum BiometryType {
    case none
    case touchID
    case faceID
  }

  enum AvailabilityType {
    case available(BiometryType)
    case lockout(BiometryType)
    case notAvailable(BiometryType)
    case notEnrolled(BiometryType)
    case passcodeNotSet(BiometryType)
    case authenticationFailed(BiometryType)
    case userCancelled(BiometryType)
    case userFallback(BiometryType)
    case none

    static func from(error: Error?, biometry: LABiometryType) -> AvailabilityType {

      // Note: When you compile this new error handling, you will see three
      // warnings complaining of using deprecated constants. This is due to a
      // combination of the way Apple added support for Face ID and the way
      // Swift imports Objective-C header files. There are some potential
      // workarounds, but they are much less “Swift-like”.
      // Since Apple is aware of the issue and plans to fix it at a future
      // date, the cleaner code is presented here.

      guard let code = (error.map { LAError(_nsError: $0 as NSError).code }) else {
        return .none
      }

      switch (code) {
      case .biometryLockout:
        return .lockout(biometry.converted)
      case .biometryNotAvailable:
        return .notAvailable(biometry.converted)
      case .biometryNotEnrolled:
        return .notEnrolled(biometry.converted)
      case .passcodeNotSet:
        return .passcodeNotSet(biometry.converted)
      case .authenticationFailed:
        return .authenticationFailed(biometry.converted)
      case .userCancel:
        return .userCancelled(biometry.converted)
      case .userFallback:
        return .userFallback(biometry.converted)
      default:
        return .none
      }
    }

    var biometricType: BiometryType {
      switch self {
      case .none, .lockout, .notAvailable, .notEnrolled, .passcodeNotSet,
           .authenticationFailed, .userCancelled, .userFallback:
        return .none
      case let .available(biometry):
        return biometry
      }
    }

    var localizedErrorMessage: String {
      switch self {
      case .available:
        return ""
      case .none:
        return "Biometric ID may not be configured!"
      case .lockout(let biometry):
        return "\(biometry) locked due to too many tries!"
      case .notAvailable(let biometry):
        return "\(biometry) is not available!"
      case .notEnrolled(let biometry):
        return "\(biometry) is not set up!"
      case .passcodeNotSet:
        return "You did not setup a PIN code!"
      case .authenticationFailed:
        return "There was a problem verifying your identity."
      case .userCancelled:
        return "You pressed cancel."
      case .userFallback:
        return "You pressed password."
      }
    }
  }

  var availability: AvailabilityType {

    let context = LAContext()
    var error: NSError?

    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
      switch context.biometryType {
      case .faceID:
        return .available(.faceID)
      case .touchID:
        return .available(.touchID)
      case .none:
        return .none
      }
    }

    // NOTE: despite what Apple Docs state, the biometryType property *is* set
    // even if canEvaluatePolicy fails.
    // See: http://www.openradar.me/36064151
    return AvailabilityType.from(error: error, biometry: context.biometryType)
  }

  func authenticateUser(completion: @escaping (String?) -> Void) {

    guard availability.biometricType != .none else {
      completion(availability.localizedErrorMessage)
      return
    }

    let context = LAContext()
    let loginReason = "Used for login"

    context.localizedFallbackTitle = "Enter Password"

    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: loginReason) { (success, evaluateError) in

      DispatchQueue.main.async {
        if success {
          completion(nil)
        } else {
          let availability = AvailabilityType.from(error: evaluateError, biometry: context.biometryType)
          completion(availability.localizedErrorMessage)
        }
      }
    }
  }
}

extension LABiometryType {
  var converted: BiometryAuth.BiometryType {
    switch self {
    case .none: return .none
    case .touchID: return .touchID
    case .faceID: return .faceID
    }
  }
}
