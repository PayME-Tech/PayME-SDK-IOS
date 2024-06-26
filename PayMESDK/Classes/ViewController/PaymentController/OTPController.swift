//
//  ViewController.swift
//  One Time Code
//
//  Created by Kyle Lee on 5/25/19.
//  Copyright © 2019 Kilo Loco. All rights reserved.
//

import UIKit

class OTP: UIViewController, PanModalPresentable {
  static var transferId: Int? = nil
  private static var onError: (([Int: Any]) -> Void)? = nil
  private static var onSuccess: (([String: AnyObject]) -> Void)? = nil

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(nameLabel)
    view.addSubview(roleLabel)
    view.addSubview(button)
    view.addSubview(image)
    view.addSubview(closeButton)
    view.addSubview(txtLabel)
    view.addSubview(txtField)
    view.addSubview(otpView)

    txtLabel.text = "confirmOTP".localize()
    roleLabel.text = "Vui lòng nhập mã OTP được gửi tới số 09833411111"
    button.setTitle("confirm".localize(), for: .normal)
    roleLabel.lineBreakMode = .byWordWrapping
    roleLabel.numberOfLines = 0
    roleLabel.textAlignment = .center
    setupConstraints()
    self.hideKeyboardWhenTappedAround()

    NotificationCenter.default.addObserver(
      self, selector: #selector(OTP.keyboardWillShow),
      name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(
      self, selector: #selector(OTP.keyboardWillHide),
      name: UIResponder.keyboardWillHideNotification, object: nil)
  }

  var longFormHeight: PanModalHeight {
    return .intrinsicHeight
  }

  @objc func keyboardWillShow(notification: NSNotification) {
    guard
      let keyboardSize =
        (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    else {
      // if keyboard size is not available for some reason, dont do anything
      return
    }
    view.safeAreaLayoutGuide.bottomAnchor.constraint(
      greaterThanOrEqualTo: otpView.bottomAnchor, constant: keyboardSize.height
    ).isActive = true
    panModalSetNeedsLayoutUpdate()
    panModalTransition(to: .longForm)
  }

  @objc func keyboardWillHide(notification: NSNotification) {
    view.safeAreaLayoutGuide.bottomAnchor.constraint(greaterThanOrEqualTo: button.bottomAnchor)
      .isActive = true
    panModalSetNeedsLayoutUpdate()
  }

  var anchorModalToLongForm: Bool {
    return false
  }

  var shouldRoundTopCorners: Bool {
    return true
  }

  func setupConstraints() {

    txtLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 19).isActive = true
    txtLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 19).isActive = true
    closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive =
      true

    image.topAnchor.constraint(equalTo: txtLabel.topAnchor, constant: 30).isActive = true
    image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    roleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    roleLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10).isActive = true
    roleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
    roleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true

    button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    button.heightAnchor.constraint(equalToConstant: 45).isActive = true
    button.topAnchor.constraint(equalTo: txtField.bottomAnchor, constant: 20).isActive = true
    button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
    button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
    button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

    txtField.topAnchor.constraint(equalTo: roleLabel.bottomAnchor).isActive = true
    txtField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    otpView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 20).isActive = true
    otpView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
    otpView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
    otpView.heightAnchor.constraint(equalToConstant: 50).isActive = true

    closeButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    view.safeAreaLayoutGuide.bottomAnchor.constraint(
      greaterThanOrEqualTo: otpView.bottomAnchor, constant: 10
    ).isActive = true
  }

  @objc
  func buttonAction(button: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }

  public static func setSuccess(onSuccess: @escaping ([String: AnyObject]) -> Void) {
    OTP.onSuccess = onSuccess
  }

  public static func setError(onError: @escaping ([Int: Any]) -> Void) {
    OTP.onError = onError
  }

  let txtField: OneTimeCodeTextField = {
    let txtField = OneTimeCodeTextField()
    txtField.defaultCharacter = "-"
    txtField.configure()
    txtField.translatesAutoresizingMaskIntoConstraints = false
    return txtField
  }()

  let closeButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(for: QRNotFound.self, named: "16Px"), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  let image: UIImageView = {
    var bgImage = UIImageView(image: UIImage(for: QRNotFound.self, named: "touchId"))
    bgImage.translatesAutoresizingMaskIntoConstraints = false
    return bgImage
  }()

  let nameLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(24, 26, 65)
    label.font = UIFont(name: "Lato-Bold", size: 25)
    label.backgroundColor = .clear
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  let roleLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(115, 115, 115)
    label.backgroundColor = .clear
    label.font = UIFont(name: "Lato-Regular", size: 15)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  let button: UIButton = {
    let button = UIButton()
    button.backgroundColor = UIColor(8, 148, 31)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.cornerRadius = 10
    return button
  }()

  let txtLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(26, 26, 26)
    label.backgroundColor = .clear
    label.font = UIFont(name: "Lato-SemiBold", size: 20)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  let otpView: OTPInput = {
    let pinField = OTPInput()
    pinField.layer.cornerRadius = 10
    pinField.clipsToBounds = true
    pinField.translatesAutoresizingMaskIntoConstraints = false
    pinField.backgroundColor = .clear
    pinField.properties.numberOfCharacters = 6
    pinField.appearance.font = .menloBold(26)  // Default to appearance.MonospacedFont.menlo(40)
    pinField.appearance.kerning = 35  // Space between characters, default to 16
    pinField.appearance.tokenColor = .clear  // token color, default to text color
    pinField.appearance.textColor = UIColor(11, 11, 11)
    pinField.properties.animateFocus = false
    pinField.appearance.backOffset = 10  // Backviews spacing between each other
    pinField.appearance.backColor = UIColor(242, 244, 243)
    pinField.appearance.backBorderWidth = 1
    pinField.appearance.backBorderColor = .clear
    pinField.appearance.backCornerRadius = 15
    pinField.appearance.backFocusColor = UIColor.clear
    pinField.appearance.backBorderFocusColor = UIColor(10, 146, 32)
    pinField.appearance.backActiveColor = UIColor(242, 244, 243)
    pinField.appearance.backBorderActiveColor = UIColor.clear
    pinField.appearance.backRounded = false
    return pinField
  }()

  override func viewDidLayoutSubviews() {
    button.applyGradient(
      colors: [
        UIColor(hexString: PayME.configColor[0]).cgColor,
        UIColor(
          hexString: PayME.configColor.count > 1 ? PayME.configColor[1] : PayME.configColor[0]
        ).cgColor,
      ], radius: 10)
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  var panScrollable: UIScrollView? {
    return nil
  }

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
