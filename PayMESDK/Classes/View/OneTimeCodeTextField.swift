//
//  OneTimeCodeTextField.swift
//  PayMESDK
//
//  Created by HuyOpen on 10/28/20.
//

import UIKit

class OneTimeCodeTextField: UITextField {
  var didEnterLastDigit: ((String) -> Void)?
  var defaultCharacter = ""
  private var isConfigured = false
  private var digitLabels = [UILabel]()
  private lazy var tapRecognizer: UITapGestureRecognizer = {
    let recognizer = UITapGestureRecognizer()
    recognizer.addTarget(self, action: #selector(becomeFirstResponder))
    return recognizer
  }()

  func configure(with slotCount: Int = 6) {
    guard isConfigured == false else {
      return
    }
    isConfigured.toggle()

    configureTextField()

    let labelsStackView = createLabelsStackView(with: slotCount)
    addSubview(labelsStackView)
    addGestureRecognizer(tapRecognizer)
    NSLayoutConstraint.activate([
      labelsStackView.topAnchor.constraint(equalTo: topAnchor),
      labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])

  }

  private func configureTextField() {
    tintColor = .clear
    textColor = .clear
    keyboardType = .numberPad
    addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    delegate = self
  }

  private func createLabelsStackView(with count: Int) -> UIStackView {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 8

    for _ in 1...count {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      label.textAlignment = .center
      label.font = .systemFont(ofSize: 30)
      label.isUserInteractionEnabled = true
      label.text = defaultCharacter
      label.layer.borderWidth = 1
      label.layer.borderColor = UIColor.red.cgColor
      label.layer.cornerRadius = 30
      stackView.addArrangedSubview(label)
      digitLabels.append(label)
    }

    return stackView
  }

  @objc private func textDidChange() {
    guard let text = self.text, text.count <= digitLabels.count else {
      return
    }

    for i in 0..<digitLabels.count {
      let currentLabel = digitLabels[i]

      if i < text.count {
        let index = text.index(text.startIndex, offsetBy: i)
        currentLabel.text = String(text[index])
      } else {
        currentLabel.text = defaultCharacter
      }
    }

    if text.count == digitLabels.count {
      didEnterLastDigit?(text)
    }
  }

}

extension OneTimeCodeTextField: UITextFieldDelegate {
  func textField(
    _ textField: UITextField, shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    guard let characterCount = textField.text?.count else {
      return false
    }
    return characterCount < digitLabels.count || string == ""
  }
}
