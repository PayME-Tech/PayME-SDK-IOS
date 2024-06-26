//
//  UserInfo.swift
//  PayMESDK
//
//  Created by HuyOpen on 9/29/20.
//  Copyright © 2020 PayME. All rights reserved.
//

import Foundation
import UIKit

public class Bank {
  var id: Int!
  var cardNumberLength: Int
  var cardPrefix: String = ""
  var enName: String = ""
  var viName: String = ""
  var shortName: String = ""
  var swiftCode: String = ""
  var isVietQr: Bool = false
  var requiredDateString: String = ""

  public init(
    id: Int, cardNumberLength: Int, cardPrefix: String, enName: String, viName: String,
    shortName: String, swiftCode: String, isVietQr: Bool = false, requiredDateString: String = ""
  ) {
    self.id = id
    self.cardNumberLength = cardNumberLength
    self.cardPrefix = cardPrefix
    self.enName = enName
    self.viName = viName
    self.shortName = shortName
    self.swiftCode = swiftCode
    self.isVietQr = isVietQr
    self.requiredDateString = requiredDateString
  }
}
