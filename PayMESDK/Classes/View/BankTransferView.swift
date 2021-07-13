//
//  BankTransferView.swift
//  PayMESDK
//
//  Created by Nam Phan Thanh on 15/06/2021.
//

import Foundation

class BankTransferView: UIView {
    var paymeInfo: BankQrView!
    var onPressSearch: () -> () = {}
    var onPressOpenVietQRBanks: () -> () = {}

    init () {
        super.init(frame: .zero)
        setupUI()
    }

    func setupUI() {
        addSubview(vStackContainer)
        vStackContainer.addArrangedSubview(bankContainer)
        vStackContainer.addArrangedSubview(transferInfo)
        vStackContainer.addArrangedSubview(openVietQRBanksButton)

        bankContainer.addSubview(titleLabel)
        bankContainer.addSubview(contentLabel)
        bankContainer.addSubview(buttonBank)

        transferInfo.addSubview(vStack)

        let divider = UIView()
        vStack.addArrangedSubview(info)
        vStack.addArrangedSubview(divider)
        vStack.addArrangedSubview(seperator)

        vStackContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
        vStackContainer.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        vStackContainer.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        titleLabel.topAnchor.constraint(equalTo: bankContainer.topAnchor, constant: 8).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: bankContainer.leadingAnchor, constant: 16).isActive = true

        contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        contentLabel.leadingAnchor.constraint(equalTo: bankContainer.leadingAnchor, constant: 16).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: buttonBank.leadingAnchor, constant: -4).isActive = true

        buttonBank.centerYAnchor.constraint(equalTo: bankContainer.centerYAnchor).isActive = true
        buttonBank.trailingAnchor.constraint(equalTo: bankContainer.trailingAnchor, constant: -16).isActive = true
        buttonBank.widthAnchor.constraint(equalToConstant: 60).isActive = true
        buttonBank.addTarget(self, action: #selector(onPressChange), for: .touchUpInside)

        bankContainer.bottomAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8).isActive = true

        vStack.topAnchor.constraint(equalTo: transferInfo.topAnchor, constant: 10).isActive = true
        vStack.leadingAnchor.constraint(equalTo: transferInfo.leadingAnchor, constant: 16).isActive = true
        vStack.trailingAnchor.constraint(equalTo: transferInfo.trailingAnchor, constant: -16).isActive = true

        divider.heightAnchor.constraint(equalToConstant: 12).isActive = true

        transferInfo.bottomAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 12).isActive = true

        openVietQRBanksButton.addTarget(self, action: #selector(onPressVietQR), for: .touchUpInside)

        bottomAnchor.constraint(equalTo: vStackContainer.bottomAnchor).isActive = true
    }

    func updateInfo(bank: BankManual?, orderTransaction: OrderTransaction) {
        guard let paymeBank = bank else { return }
        contentLabel.text = paymeBank.bankName
        paymeInfo?.removeFromSuperview()
        note.removeFromSuperview()
        transferInfo.removeDashedLines()
        paymeInfo = BankQrView(qrString: paymeBank.qrCode, bank: paymeBank)

        let normalText1 = NSMutableAttributedString(string: "bankTransferContent1".localize(), attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .regular),
            .foregroundColor: UIColor(0, 0, 0)
        ])
        let normalText2 = NSMutableAttributedString(string: "bankTransferContent2".localize(), attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .regular),
            .foregroundColor: UIColor(0, 0, 0)
        ])
        normalText1.append(NSMutableAttributedString(string: "\(formatMoney(input: orderTransaction.total ?? 0)) đ ", attributes: [
            .font: UIFont.systemFont(ofSize: 18, weight: .bold),
            .foregroundColor: UIColor(236, 42, 42)
        ]))
        normalText1.append(normalText2)
        info.attributedText = normalText1

        vStack.addArrangedSubview(paymeInfo)
        vStack.addArrangedSubview(note)
        paymeInfo.leadingAnchor.constraint(equalTo: vStack.leadingAnchor).isActive = true
        layoutIfNeeded()
        seperator.createDashedLine( from: CGPoint(x: 0, y: 0), to: CGPoint(x: seperator.frame.size.width, y: 0), color: UIColor(142, 142, 142), strokeLength: 4, gapLength: 4, width: 1)
        transferInfo.addLineDashedStroke(pattern: [4, 4], radius: 16, color: UIColor(142, 142, 142).cgColor)
    }

    func canChangeBank(_ value: Bool = true) {
        if (value == true) {
            bankContainer.isHidden = false
        } else {
            bankContainer.isHidden = true
        }
    }

    @objc func onPressChange() {
        onPressSearch()
    }
    @objc func onPressVietQR() {
        onPressOpenVietQRBanks()
    }

    let vStackContainer: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 8
        return stack
    }()

    let bankContainer: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor(242, 246, 247)
        container.layer.cornerRadius = 13
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(165, 174, 184)
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.text = "bank".localize()
        return label
    }()

    let buttonBank: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(hexString: PayME.configColor[0]), for: .normal)
        button.setTitle("change".localize(), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        return button
    }()

    let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(0, 0, 0)
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()

    let transferInfo: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        return view
    }()
    let vStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    let info: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()

    let seperator = UIView()

    let openVietQRBanksButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(for: BankTransferView.self, named: "bannerVietQr"), for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "openVietQRBankList".localize() + " ",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                    .foregroundColor: UIColor(hexString: PayME.configColor[0]),
                    .underlineStyle: NSUnderlineStyle.single.rawValue
                ]), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()

    let note: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(0, 0, 0)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.text = "bankTransferContent3".localize()
        return label
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}