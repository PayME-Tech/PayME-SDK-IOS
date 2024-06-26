//
//  Extension+Color.swift
//  PayMESDK
//
//  Created by Minh Khoa on 09/06/2021.
//

import Foundation
import UIKit

extension UIColor {
  func lighter(by percentage: CGFloat = 30.0) -> UIColor {
    self.adjust(by: abs(percentage)) ?? self
  }

  func darker(by percentage: CGFloat = 30.0) -> UIColor {
    self.adjust(by: -1 * abs(percentage)) ?? self
  }

  func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
      return UIColor(
        red: min(red + percentage / 100, 1.0),
        green: min(green + percentage / 100, 1.0),
        blue: min(blue + percentage / 100, 1.0),
        alpha: alpha)
    } else {
      return nil
    }
  }
}
