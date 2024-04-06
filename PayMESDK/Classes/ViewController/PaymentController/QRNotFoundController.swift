//
//  ViewController.swift
//  One Time Code
//
//  Created by Kyle Lee on 5/25/19.
//  Copyright © 2019 Kilo Loco. All rights reserved.
//

import UIKit

class QRNotFound: UIViewController, PanModalPresentable {
  private var onPress: () -> Void

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(nameLabel)
    view.addSubview(roleLabel)
    view.addSubview(button)
    view.addSubview(image)
    view.addSubview(closeButton)
    nameLabel.text = "notFound".localize()
    roleLabel.text = "notFoundQRContent".localize()
    button.setTitle("close".localize(), for: .normal)
    roleLabel.lineBreakMode = .byWordWrapping
    roleLabel.numberOfLines = 0
    roleLabel.textAlignment = .center
    setupConstraints()
  }

  var panScrollable: UIScrollView? {
    return nil
  }

  var longFormHeight: PanModalHeight {
    return .intrinsicHeight
  }

  var anchorModalToLongForm: Bool {
    return false
  }

  var shouldRoundTopCorners: Bool {
    return true
  }

  func setupConstraints() {
    closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 19).isActive = true
    closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive =
      true
    image.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
    image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    nameLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20.0).isActive = true
    roleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    roleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 18.0).isActive = true
    roleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
    roleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
    button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    button.heightAnchor.constraint(equalToConstant: 45).isActive = true
    button.topAnchor.constraint(equalTo: roleLabel.bottomAnchor, constant: 20).isActive = true
    button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
    button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
    button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    closeButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    view.safeAreaLayoutGuide.bottomAnchor.constraint(
      greaterThanOrEqualTo: button.bottomAnchor, constant: 10
    )
    .isActive = true

  }

  @objc
  func buttonAction(button: UIButton) {
    dismiss(animated: true) {
      self.onPress()
    }
  }

  let closeButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(for: QRNotFound.self, named: "16Px"), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  let image: UIImageView = {
    var bgImage = UIImageView(image: UIImage(for: QRNotFound.self, named: "qrCodeNotFound"))
    bgImage.translatesAutoresizingMaskIntoConstraints = false
    return bgImage
  }()

  let nameLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(24, 26, 65)
    label.font = UIFont.systemFont(ofSize: 21, weight: .semibold)
    label.backgroundColor = .clear
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  let roleLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(115, 115, 115)
    label.backgroundColor = .clear
    label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
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

  override func viewDidLayoutSubviews() {
    button.applyGradient(
      colors: [
        UIColor(hexString: PayME.configColor[0]).cgColor,
        UIColor(
          hexString: PayME.configColor.count > 1 ? PayME.configColor[1] : PayME.configColor[0]
        ).cgColor,
      ], radius: 10)
  }

  init(onPress: @escaping () -> Void = {}) {
    self.onPress = onPress
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}
