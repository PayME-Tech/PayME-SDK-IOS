//
//  KYCController.swift
//  PayMESDK
//
//  Created by HuyOpen on 11/23/20.
//

import UIKit

class KYCBackController: UIViewController {
    public var kycImage : UIImage?
    public var kycImageBack: UIImage?
    public var active : Int?
    let screenSize:CGRect = UIScreen.main.bounds

    let imageView: UIImageView = {
        let bundle = Bundle(for: KYCFrontController.self)
        let bundleURL = bundle.resourceURL?.appendingPathComponent("PayMESDK.bundle")
        let resourceBundle = Bundle(url: bundleURL!)
        let image = UIImage(named: "fails", in: resourceBundle, compatibleWith: nil)
        var bgImage = UIImageView(image: nil)
        bgImage.layer.cornerRadius = 15
        bgImage.layer.masksToBounds = true
        bgImage.translatesAutoresizingMaskIntoConstraints = false
        return bgImage
    }()
    
    let titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor(24,26,65)
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.text = "Xác nhận hình chụp"
        return titleLabel
    }()
    
    let confirmTitle : UILabel = {
        let confirmTitle = UILabel()
        confirmTitle.textColor = UIColor(24,26,65)
        confirmTitle.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        confirmTitle.translatesAutoresizingMaskIntoConstraints = false
        confirmTitle.textAlignment = .center
        confirmTitle.lineBreakMode = .byWordWrapping
        confirmTitle.numberOfLines = 0
        confirmTitle.text = "Vui lòng xác nhận hình ảnh rõ ràng và dễ đọc, trước khi tiếp tục"
        return confirmTitle
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        let bundle = Bundle(for: KYCFrontController.self)
        let bundleURL = bundle.resourceURL?.appendingPathComponent("PayMESDK.bundle")
        let resourceBundle = Bundle(url: bundleURL!)
        let image = UIImage(named: "32Px", in: resourceBundle, compatibleWith: nil)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let captureAgain: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(8,148,31).withAlphaComponent(0.3)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.setTitle("CHỤP LẠI", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(UIColor(10,146,32), for: .normal)
        return button
    }()
    
    let confirm: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(8,148,31)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.setTitle("TIẾP TỤC", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backButton)
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(captureAgain)
        view.addSubview(confirm)
        view.addSubview(confirmTitle)
        view.backgroundColor = .white
        imageView.image = self.kycImageBack
        
        if #available(iOS 11, *) {
          let guide = view.safeAreaLayoutGuide
          NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.4),
            captureAgain.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -18),
            confirm.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -18)
           ])
        } else {
           let standardSpacing: CGFloat = 8.0
           NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: standardSpacing),
            titleLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: standardSpacing + 5),
            captureAgain.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -standardSpacing),
            confirm.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -standardSpacing)
           ])
        }
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        captureAgain.heightAnchor.constraint(equalToConstant: 50).isActive = true
        captureAgain.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        captureAgain.widthAnchor.constraint(equalToConstant: (screenSize.width / 2) - 20).isActive = true
        
        confirm.heightAnchor.constraint(equalToConstant: 50).isActive = true
        confirm.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        confirm.widthAnchor.constraint(equalToConstant: (screenSize.width / 2) - 20).isActive = true
        
        imageView.widthAnchor.constraint(equalToConstant: screenSize.width - 32).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: (screenSize.width-32) * 0.67).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 70).isActive = true
        
        confirmTitle.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 21).isActive = true
        confirmTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        confirmTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        captureAgain.addTarget(self, action: #selector(back), for: .touchUpInside)
        confirm.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func confirmAction() {
        KYCController.imageDocument = [self.kycImage!,self.kycImageBack!]
        KYCController.active = self.active
        let popupKYC = PopupKYC()
        if (KYCController.flowKYC!["kycFace"] == true) {
            popupKYC.active = 1
            PayME.currentVC?.present(popupKYC, animated: true)

        } else if (KYCController.flowKYC!["kycVideo"] == true) {
            popupKYC.active = 2
            PayME.currentVC?.present(popupKYC, animated: true)
            
        } else {
            KYCController.uploadKYC()
        }
    }
    override func viewDidLayoutSubviews() {
        let colorButton = [UIColor(hexString: PayME.configColor[0]).cgColor, UIColor(hexString: PayME.configColor.count > 1 ? PayME.configColor[1] : PayME.configColor[0]).cgColor]
        captureAgain.applyGradient(colors: colorButton, radius: 10)
        captureAgain.setTitleColor(.white, for: .normal)
        confirm.applyGradient(colors: colorButton, radius: 10)
        confirm.setTitleColor(.white, for: .normal)
    }
}