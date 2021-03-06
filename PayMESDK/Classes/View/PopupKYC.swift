//
//  PopUpWindow.swift
//  PopUpWindowExample
//
//  Created by John Codeos on 1/18/20.
//  Copyright © 2020 John Codeos. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class PopupKYC: UIViewController {
    var active: Int!

    private let popupFace: PopupFace = {
        let popUpWindowView = PopupFace()
        popUpWindowView.translatesAutoresizingMaskIntoConstraints = false
        return popUpWindowView
    }()

    private let popupVideo: PopupVideo = {
        let popUpWindowView = PopupVideo()
        popUpWindowView.translatesAutoresizingMaskIntoConstraints = false
        return popUpWindowView
    }()

    private let popupDocument: PopupDocument = {
        let popUpWindowView = PopupDocument()
        popUpWindowView.translatesAutoresizingMaskIntoConstraints = false
        return popUpWindowView
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        definesPresentationContext = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(24, 26, 65).withAlphaComponent(0.6)
        if (active! == 1) {
            view.addSubview(popupFace)
            setupViewFace()
        } else if (active! == 2) {
            view.addSubview(popupVideo)
            setupViewVideo()
        } else {
            view.addSubview(popupDocument)
            setupViewDocument()
        }
    }

    func setupViewDocument() {
        popupDocument.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        popupDocument.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        popupDocument.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popupDocument.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popupDocument.continueButton.addTarget(self, action: #selector(goToCamera), for: .touchUpInside)
    }

    func setupViewFace() {
        popupFace.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        popupFace.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        popupFace.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popupFace.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popupFace.continueButton.addTarget(self, action: #selector(goToCamera), for: .touchUpInside)
    }

    func setupViewVideo() {
        popupVideo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        popupVideo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        popupVideo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popupVideo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        popupVideo.continueButton.addTarget(self, action: #selector(goToCamera), for: .touchUpInside)
    }

    @objc func goToCamera() {
        close()
        if (active == 1) {
            let avatarController = AvatarController()
            if PayME.currentVC?.navigationController != nil {
                PayME.currentVC?.navigationController?.pushViewController(avatarController, animated: true)
            } else {
                PayME.currentVC?.present(avatarController, animated: true, completion: nil)
            }
        } else if (active == 2) {
            let videoController = VideoController()
            if PayME.currentVC?.navigationController != nil {
                PayME.currentVC?.navigationController?.pushViewController(videoController, animated: true)
            } else {
                PayME.currentVC?.present(videoController, animated: true, completion: nil)
            }
        } else {
            let kycDocument = KYCCameraController()
            if PayME.currentVC?.navigationController != nil {
                PayME.currentVC?.navigationController?.pushViewController(kycDocument, animated: true)
            } else {
                PayME.currentVC?.present(kycDocument, animated: true, completion: nil)
            }
        }
    }


    func close() {
        dismiss(animated: true, completion: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        let touch = touches.first
        guard let location = touch?.location(in: view) else {
            return
        }
        if (active == 1) {
            if !popupFace.frame.contains(location) {
                close()
            }
        } else if (active == 2) {
            if !popupVideo.frame.contains(location) {
                close()
            }
        } else {
            if !popupDocument.frame.contains(location) {
                close()
            }
        }

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}

private class PopupDocument: UIView {
    let rootView = UIStackView()
    let screenSize: CGRect = UIScreen.main.bounds
    let animationView = AnimationView()


    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor(24, 26, 65)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "kycContent7".localize()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        return label

    }()

    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(148, 148, 148)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "kycContent8".localize()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        return label

    }()


    let hint1Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(38, 46, 52)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "kycContent9".localize()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    let hint2Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(38, 46, 52)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "kycContent10".localize()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    let hint3Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(38, 46, 52)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "kycContent11".localize()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()


    let continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexString: PayME.configColor[0])
        button.setTitle("continue".localize(), for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1), for: UIControl.State.normal)
        button.layer.cornerRadius = 20
        return button
    }()

    let iconChecked1: UIImageView = {
        var bgImage = UIImageView(image: UIImage(for: QRScannerController.self, named: "checkBullet"))
        bgImage.translatesAutoresizingMaskIntoConstraints = false
        bgImage.image = bgImage.image?.withRenderingMode(.alwaysTemplate)
        bgImage.tintColor = UIColor(hexString: PayME.configColor[0])
        return bgImage
    }()

    let iconChecked2: UIImageView = {
        var bgImage = UIImageView(image: UIImage(for: QRScannerController.self, named: "checkBullet"))
        bgImage.translatesAutoresizingMaskIntoConstraints = false
        bgImage.image = bgImage.image?.withRenderingMode(.alwaysTemplate)
        bgImage.tintColor = UIColor(hexString: PayME.configColor[0])
        return bgImage
    }()

    let iconChecked3: UIImageView = {
        var bgImage = UIImageView(image: UIImage(for: QRScannerController.self, named: "checkBullet"))
        bgImage.translatesAutoresizingMaskIntoConstraints = false
        bgImage.image = bgImage.image?.withRenderingMode(.alwaysTemplate)
        bgImage.tintColor = UIColor(hexString: PayME.configColor[0])
        return bgImage
    }()

    let hint1 = UIStackView()
    let hint2 = UIStackView()
    let hint3 = UIStackView()

    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .white
        layer.cornerRadius = 15

        addSubview(rootView)

        rootView.addSubview(continueButton)
        rootView.addSubview(animationView)
        rootView.addSubview(titleLabel)
        rootView.addSubview(contentLabel)
        rootView.addSubview(hint1)
        rootView.addSubview(hint2)
        rootView.addSubview(hint3)

        hint1.addSubview(hint1Label)
        hint1.addSubview(iconChecked1)

        hint2.addSubview(hint2Label)
        hint2.addSubview(iconChecked2)

        hint3.addSubview(hint3Label)
        hint3.addSubview(iconChecked3)

        hint1.translatesAutoresizingMaskIntoConstraints = false
        hint1.axis = .horizontal
        hint1.alignment = .leading

        hint2.translatesAutoresizingMaskIntoConstraints = false
        hint2.axis = .horizontal
        hint2.alignment = .leading

        hint3.translatesAutoresizingMaskIntoConstraints = false
        hint3.axis = .horizontal
        hint3.alignment = .leading

        rootView.translatesAutoresizingMaskIntoConstraints = false
        rootView.axis = .vertical
        rootView.alignment = .center


        rootView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        rootView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        rootView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        rootView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.widthAnchor.constraint(equalToConstant: 193).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 213).isActive = true
        animationView.topAnchor.constraint(equalTo: rootView.topAnchor, constant: 22).isActive = true
        animationView.centerXAnchor.constraint(equalTo: rootView.centerXAnchor).isActive = true
        animationView.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)

        titleLabel.centerXAnchor.constraint(equalTo: rootView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 5).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: -20).isActive = true

        contentLabel.centerXAnchor.constraint(equalTo: rootView.centerXAnchor).isActive = true
        contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 11).isActive = true
        contentLabel.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: 20).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: -20).isActive = true

        hint1.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 40).isActive = true
        hint1.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: 20).isActive = true
        hint1.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: -20).isActive = true

        iconChecked1.widthAnchor.constraint(equalToConstant: 15).isActive = true
        iconChecked1.heightAnchor.constraint(equalToConstant: 12).isActive = true
        iconChecked1.topAnchor.constraint(equalTo: hint1.topAnchor).isActive = true
        iconChecked1.leadingAnchor.constraint(equalTo: hint1.leadingAnchor).isActive = true

        hint1Label.topAnchor.constraint(equalTo: hint1.topAnchor).isActive = true
        hint1Label.leadingAnchor.constraint(equalTo: iconChecked1.trailingAnchor, constant: 14).isActive = true
        hint1Label.trailingAnchor.constraint(equalTo: hint1.trailingAnchor).isActive = true
        hint1Label.bottomAnchor.constraint(equalTo: hint1.bottomAnchor).isActive = true

        hint2.topAnchor.constraint(equalTo: hint1.bottomAnchor, constant: 10).isActive = true
        hint2.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: 20).isActive = true
        hint2.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: -20).isActive = true

        iconChecked2.widthAnchor.constraint(equalToConstant: 15).isActive = true
        iconChecked2.heightAnchor.constraint(equalToConstant: 12).isActive = true
        iconChecked2.topAnchor.constraint(equalTo: hint2.topAnchor).isActive = true
        iconChecked2.leadingAnchor.constraint(equalTo: hint2.leadingAnchor).isActive = true

        hint2Label.topAnchor.constraint(equalTo: hint2.topAnchor).isActive = true
        hint2Label.leadingAnchor.constraint(equalTo: iconChecked2.trailingAnchor, constant: 14).isActive = true
        hint2Label.trailingAnchor.constraint(equalTo: hint2.trailingAnchor).isActive = true
        hint2Label.bottomAnchor.constraint(equalTo: hint2.bottomAnchor).isActive = true

        hint3.topAnchor.constraint(equalTo: hint2.bottomAnchor, constant: 10).isActive = true
        hint3.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: 20).isActive = true
        hint3.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: -20).isActive = true

        iconChecked3.widthAnchor.constraint(equalToConstant: 15).isActive = true
        iconChecked3.heightAnchor.constraint(equalToConstant: 12).isActive = true
        iconChecked3.topAnchor.constraint(equalTo: hint3.topAnchor).isActive = true
        iconChecked3.leadingAnchor.constraint(equalTo: hint3.leadingAnchor).isActive = true

        hint3Label.topAnchor.constraint(equalTo: hint3.topAnchor).isActive = true
        hint3Label.leadingAnchor.constraint(equalTo: iconChecked3.trailingAnchor, constant: 14).isActive = true
        hint3Label.trailingAnchor.constraint(equalTo: hint3.trailingAnchor).isActive = true
        hint3Label.bottomAnchor.constraint(equalTo: hint3.bottomAnchor).isActive = true

        continueButton.topAnchor.constraint(equalTo: hint3.bottomAnchor, constant: 24).isActive = true
        continueButton.centerXAnchor.constraint(equalTo: rootView.centerXAnchor).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        continueButton.widthAnchor.constraint(equalTo: rootView.widthAnchor, constant: -34).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: rootView.bottomAnchor, constant: -20).isActive = true

        let bundle = Bundle(for: ResultView.self)
        let bundleURL = bundle.resourceURL?.appendingPathComponent("PayMESDK.bundle")
        let resourceBundle = Bundle(url: bundleURL!)
        let animation = Animation.named("Chup_CMNN", bundle: resourceBundle!)
        animationView.animation = animation

        let color = ColorValueProvider(UIColor(hexString: PayME.configColor[0]).lottieColorValue)
        let keyPath = AnimationKeypath(keypath: "CMNN Outlines.Group 1.**.Color")
        let keyPath1 = AnimationKeypath(keypath: "CMNN Outlines.Group 2.**.Color")
        let keyPath2 = AnimationKeypath(keypath: "CMNN Outlines.Group 14.**.Color")
        let keyPath3 = AnimationKeypath(keypath: "Chup_xanh.**.Fill 1.Color")
        let keyPath4 = AnimationKeypath(keypath: "Focus_xanh.**.Fill 1.Color")
        let keyPath5 = AnimationKeypath(keypath: "CMNN_xanh.**.Fill 1.Color")
        let keyPath6 = AnimationKeypath(keypath: "CMNN_2_xanh.**.Fill 1.Color")
        let keyPath7 = AnimationKeypath(keypath: "Bo_xanh.**.Stroke 1.Color")
        animationView.setValueProvider(color, keypath: keyPath)
        animationView.setValueProvider(color, keypath: keyPath1)
        animationView.setValueProvider(color, keypath: keyPath2)
        animationView.setValueProvider(color, keypath: keyPath3)
        animationView.setValueProvider(color, keypath: keyPath4)
        animationView.setValueProvider(color, keypath: keyPath5)
        animationView.setValueProvider(color, keypath: keyPath6)
        animationView.setValueProvider(color, keypath: keyPath7)

        print(animationView.logHierarchyKeypaths())

        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class PopupFace: UIView {

    let rootView = UIStackView()
    let screenSize: CGRect = UIScreen.main.bounds
    let animationView = AnimationView()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor(24, 26, 65)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "kycContent12".localize()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        return label

    }()

    let hint1Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(38, 46, 52)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "kycContent13".localize()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0

        return label
    }()

    let hint2Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(38, 46, 52)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "kycContent14".localize()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()


    let continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexString: PayME.configColor[0])
        button.setTitle("continue".localize(), for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1), for: UIControl.State.normal)
        button.layer.cornerRadius = 20
        return button
    }()

    let imageView: UIImageView = {
        var bgImage = UIImageView(image: UIImage(for: QRScannerController.self, named: "scanCmnd"))
        bgImage.translatesAutoresizingMaskIntoConstraints = false
        return bgImage
    }()

    let iconChecked1: UIImageView = {
        var bgImage = UIImageView(image: UIImage(for: QRScannerController.self, named: "checkBullet"))
        bgImage.translatesAutoresizingMaskIntoConstraints = false
        bgImage.image = bgImage.image?.withRenderingMode(.alwaysTemplate)
        bgImage.tintColor = UIColor(hexString: PayME.configColor[0])
        return bgImage
    }()

    let iconChecked2: UIImageView = {
        var bgImage = UIImageView(image: UIImage(for: QRScannerController.self, named: "checkBullet"))
        bgImage.translatesAutoresizingMaskIntoConstraints = false
        bgImage.image = bgImage.image?.withRenderingMode(.alwaysTemplate)
        bgImage.tintColor = UIColor(hexString: PayME.configColor[0])
        return bgImage
    }()

    let hint1 = UIStackView()
    let hint2 = UIStackView()

    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .white
        layer.cornerRadius = 15

        addSubview(rootView)

        rootView.addSubview(continueButton)
        rootView.addSubview(animationView)
        rootView.addSubview(titleLabel)
        rootView.addSubview(hint1)
        rootView.addSubview(hint2)

        hint1.addSubview(hint1Label)
        hint1.addSubview(iconChecked1)

        hint2.addSubview(hint2Label)
        hint2.addSubview(iconChecked2)

        hint1.translatesAutoresizingMaskIntoConstraints = false
        hint1.axis = .horizontal
        hint1.alignment = .leading
        hint2.translatesAutoresizingMaskIntoConstraints = false
        hint2.axis = .horizontal
        hint2.alignment = .leading

        rootView.translatesAutoresizingMaskIntoConstraints = false
        rootView.axis = .vertical
        rootView.alignment = .center

        rootView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        rootView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        rootView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        rootView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.widthAnchor.constraint(equalToConstant: 193).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 213).isActive = true
        animationView.topAnchor.constraint(equalTo: rootView.topAnchor, constant: 22).isActive = true
        animationView.centerXAnchor.constraint(equalTo: rootView.centerXAnchor).isActive = true
        animationView.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)

        titleLabel.centerXAnchor.constraint(equalTo: rootView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: -20).isActive = true

        hint1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40).isActive = true
        hint1.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: 20).isActive = true
        hint1.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: -20).isActive = true

        iconChecked1.widthAnchor.constraint(equalToConstant: 15).isActive = true
        iconChecked1.heightAnchor.constraint(equalToConstant: 12).isActive = true
        iconChecked1.topAnchor.constraint(equalTo: hint1.topAnchor).isActive = true
        iconChecked1.leadingAnchor.constraint(equalTo: hint1.leadingAnchor).isActive = true

        hint1Label.topAnchor.constraint(equalTo: hint1.topAnchor).isActive = true
        hint1Label.leadingAnchor.constraint(equalTo: iconChecked1.trailingAnchor, constant: 14).isActive = true
        hint1Label.trailingAnchor.constraint(equalTo: hint1.trailingAnchor).isActive = true
        hint1Label.bottomAnchor.constraint(equalTo: hint1.bottomAnchor).isActive = true

        hint2.topAnchor.constraint(equalTo: hint1.bottomAnchor, constant: 10).isActive = true
        hint2.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: 20).isActive = true
        hint2.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: -20).isActive = true

        iconChecked2.widthAnchor.constraint(equalToConstant: 15).isActive = true
        iconChecked2.heightAnchor.constraint(equalToConstant: 12).isActive = true
        iconChecked2.topAnchor.constraint(equalTo: hint2.topAnchor).isActive = true
        iconChecked2.leadingAnchor.constraint(equalTo: hint2.leadingAnchor).isActive = true

        hint2Label.topAnchor.constraint(equalTo: hint2.topAnchor).isActive = true
        hint2Label.leadingAnchor.constraint(equalTo: iconChecked2.trailingAnchor, constant: 14).isActive = true
        hint2Label.trailingAnchor.constraint(equalTo: hint2.trailingAnchor).isActive = true
        hint2Label.bottomAnchor.constraint(equalTo: hint2.bottomAnchor).isActive = true

        continueButton.topAnchor.constraint(equalTo: hint2.bottomAnchor, constant: 24).isActive = true
        continueButton.centerXAnchor.constraint(equalTo: rootView.centerXAnchor).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        continueButton.widthAnchor.constraint(equalTo: rootView.widthAnchor, constant: -34).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: rootView.bottomAnchor, constant: -20).isActive = true

        let bundle = Bundle(for: ResultView.self)
        let bundleURL = bundle.resourceURL?.appendingPathComponent("PayMESDK.bundle")
        let resourceBundle = Bundle(url: bundleURL!)
        let animation = Animation.named("take_face", bundle: resourceBundle!)
        animationView.animation = animation

        let color = ColorValueProvider(UIColor(hexString: PayME.configColor[0]).lottieColorValue)
        let keyPath = AnimationKeypath(keypath: "Focus.**.Color")
        let keyPath1 = AnimationKeypath(keypath: "Mat.**.Fill 1.Color")
        animationView.setValueProvider(color, keypath: keyPath)
        animationView.setValueProvider(color, keypath: keyPath1)

        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
    }

    func setupAnimation() {
        let bundle = Bundle(for: ResultView.self)
        let bundleURL = bundle.resourceURL?.appendingPathComponent("PayMESDK.bundle")
        let resourceBundle = Bundle(url: bundleURL!)
        let animation = Animation.named("take_face", bundle: resourceBundle!)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        rootView.addSubview(animationView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private class PopupVideo: UIView {
    let rootView = UIStackView()
    let screenSize: CGRect = UIScreen.main.bounds

    let animationView = AnimationView()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor(24, 26, 65)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "kycContent15".localize()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        return label

    }()

    let hint1Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(38, 46, 52)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "kycContent16".localize()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()

    let hint2Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(38, 46, 52)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "kycContent17".localize()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()


    let continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexString: PayME.configColor[0])
        button.setTitle("continue".localize(), for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1), for: UIControl.State.normal)
        button.layer.cornerRadius = 20
        return button
    }()

    let imageView: UIImageView = {
        var bgImage = UIImageView(image: UIImage(for: QRScannerController.self, named: "scanCmnd"))
        bgImage.translatesAutoresizingMaskIntoConstraints = false
        return bgImage
    }()

    let iconChecked1: UIImageView = {
        var bgImage = UIImageView(image: UIImage(for: QRScannerController.self, named: "checkBullet"))
        bgImage.translatesAutoresizingMaskIntoConstraints = false
        bgImage.image = bgImage.image?.withRenderingMode(.alwaysTemplate)
        bgImage.tintColor = UIColor(hexString: PayME.configColor[0])
        return bgImage
    }()

    let iconChecked2: UIImageView = {
        var bgImage = UIImageView(image: UIImage(for: QRScannerController.self, named: "checkBullet"))
        bgImage.translatesAutoresizingMaskIntoConstraints = false
        bgImage.image = bgImage.image?.withRenderingMode(.alwaysTemplate)
        bgImage.tintColor = UIColor(hexString: PayME.configColor[0])
        return bgImage
    }()

    let hint1 = UIStackView()
    let hint2 = UIStackView()

    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .white
        layer.cornerRadius = 15


        addSubview(rootView)

        rootView.addSubview(continueButton)
        rootView.addSubview(titleLabel)
        rootView.addSubview(hint1)
        rootView.addSubview(hint2)
        rootView.addSubview(animationView)

        hint1.addSubview(hint1Label)
        hint1.addSubview(iconChecked1)

        hint2.addSubview(hint2Label)
        hint2.addSubview(iconChecked2)

        hint1.translatesAutoresizingMaskIntoConstraints = false
        hint1.axis = .horizontal
        hint1.alignment = .leading
        hint2.translatesAutoresizingMaskIntoConstraints = false
        hint2.axis = .horizontal
        hint2.alignment = .leading

        rootView.translatesAutoresizingMaskIntoConstraints = false
        rootView.axis = .vertical
        rootView.alignment = .center


        rootView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        rootView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        rootView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        rootView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.widthAnchor.constraint(equalToConstant: 193).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: 213).isActive = true
        animationView.topAnchor.constraint(equalTo: rootView.topAnchor, constant: 22).isActive = true
        animationView.centerXAnchor.constraint(equalTo: rootView.centerXAnchor).isActive = true
        animationView.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)

        titleLabel.centerXAnchor.constraint(equalTo: rootView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: -20).isActive = true

        hint1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40).isActive = true
        hint1.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: 20).isActive = true
        hint1.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: -20).isActive = true

        iconChecked1.widthAnchor.constraint(equalToConstant: 15).isActive = true
        iconChecked1.heightAnchor.constraint(equalToConstant: 12).isActive = true
        iconChecked1.topAnchor.constraint(equalTo: hint1.topAnchor).isActive = true
        iconChecked1.leadingAnchor.constraint(equalTo: hint1.leadingAnchor).isActive = true

        hint1Label.topAnchor.constraint(equalTo: hint1.topAnchor).isActive = true
        hint1Label.leadingAnchor.constraint(equalTo: iconChecked1.trailingAnchor, constant: 14).isActive = true
        hint1Label.trailingAnchor.constraint(equalTo: hint1.trailingAnchor).isActive = true
        hint1Label.bottomAnchor.constraint(equalTo: hint1.bottomAnchor).isActive = true

        hint2.topAnchor.constraint(equalTo: hint1.bottomAnchor, constant: 10).isActive = true
        hint2.leadingAnchor.constraint(equalTo: rootView.leadingAnchor, constant: 20).isActive = true
        hint2.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: -20).isActive = true

        iconChecked2.widthAnchor.constraint(equalToConstant: 15).isActive = true
        iconChecked2.heightAnchor.constraint(equalToConstant: 12).isActive = true
        iconChecked2.topAnchor.constraint(equalTo: hint2.topAnchor).isActive = true
        iconChecked2.leadingAnchor.constraint(equalTo: hint2.leadingAnchor).isActive = true

        hint2Label.topAnchor.constraint(equalTo: hint2.topAnchor).isActive = true
        hint2Label.leadingAnchor.constraint(equalTo: iconChecked2.trailingAnchor, constant: 14).isActive = true
        hint2Label.trailingAnchor.constraint(equalTo: hint2.trailingAnchor).isActive = true
        hint2Label.bottomAnchor.constraint(equalTo: hint2.bottomAnchor).isActive = true

        continueButton.topAnchor.constraint(equalTo: hint2.bottomAnchor, constant: 24).isActive = true
        continueButton.centerXAnchor.constraint(equalTo: rootView.centerXAnchor).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        continueButton.widthAnchor.constraint(equalTo: rootView.widthAnchor, constant: -34).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: rootView.bottomAnchor, constant: -20).isActive = true

        let bundle = Bundle(for: ResultView.self)
        let bundleURL = bundle.resourceURL?.appendingPathComponent("PayMESDK.bundle")
        let resourceBundle = Bundle(url: bundleURL!)
        let animation = Animation.named("take_video", bundle: resourceBundle!)
        animationView.animation = animation

        let color = ColorValueProvider(UIColor(hexString: PayME.configColor[0]).lottieColorValue)
        let keyPath = AnimationKeypath(keypath: "Focus.**.Fill 1.Color")
        let keyPath1 = AnimationKeypath(keypath: "CMNN_bg.Group 6.**.Fill 1.Color")
        animationView.setValueProvider(color, keypath: keyPath)
        animationView.setValueProvider(color, keypath: keyPath1)

        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
