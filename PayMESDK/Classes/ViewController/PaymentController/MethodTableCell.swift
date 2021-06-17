//
//  MethodTableCell.swift
//  PayMESDK
//
//  Created by HuyOpen on 10/28/20.
//

import UIKit

class Method: UITableViewCell {
    var methodView: MethodView = MethodView(title: "")

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isAccessibilityElement = true
        backgroundColor = .white
        addSubview(methodView)
        methodView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        methodView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        methodView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        methodView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0.8196078431, green: 0.8235294118, blue: 0.8274509804, alpha: 1).withAlphaComponent(0.11)
        selectedBackgroundView = backgroundView
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func openWallet(action: PayME.Action, amount: Int? = nil, payMEFunction: PayMEFunction, orderTransaction: OrderTransaction) {
        PayME.currentVC!.dismiss(animated: true)
        payMEFunction.openWallet(
                false, PayME.currentVC!, action, amount, orderTransaction.note,
                orderTransaction.extraData, "", false, { dictionary in },
                { dictionary in }
        )
    }

    func configure(with presentable: PaymentMethod, payMEFunction: PayMEFunction, orderTransaction: OrderTransaction) {
        if (presentable.type == MethodType.WALLET.rawValue) {
            methodView.title = "Số dư ví"
            methodView.image.image = UIImage(for: PaymentModalController.self, named: "iconWallet")
            methodView.methodDescription = presentable.feeDescription
            if payMEFunction.accessToken == "" {
                methodView.buttonTitle = "Kích hoạt ngay"
                methodView.note = "(*) Vui lòng kích hoạt tài khoản ví trước khi sử dụng"
                methodView.onPress = {
                    self.openWallet(action: PayME.Action.OPEN, payMEFunction: payMEFunction, orderTransaction: orderTransaction)
                }
            } else if payMEFunction.kycState != "APPROVED" {
                methodView.buttonTitle = "Định danh ngay"
                methodView.note = "(*) Vui lòng định danh tài khoản ví trước khi sử dụng"
                methodView.onPress = {
                    PayME.currentVC?.dismiss(animated: true) { payMEFunction.KYC(PayME.currentVC!, { }, { dictionary in}) }
                }
            } else {
                let balance = presentable.dataWallet?.balance ?? 0
                methodView.content = "(\(formatMoney(input: balance))đ)"
                if balance < orderTransaction.amount {
                    methodView.buttonTitle = "Nạp tiền"
                    methodView.note = "(*) Chọn phương thức khác hoặc nạp thêm để thanh toán"
                    methodView.onPress = {
                        self.openWallet(action: PayME.Action.DEPOSIT, amount: orderTransaction.amount - balance, payMEFunction: payMEFunction, orderTransaction: orderTransaction)
                    }
                } else {
                    methodView.buttonTitle = nil
                    methodView.note = nil
                }
            }
        } else {
            methodView.title = presentable.title
            methodView.content = presentable.label
            methodView.buttonTitle = nil
            methodView.note = nil
            methodView.methodDescription = presentable.feeDescription
            switch presentable.type {
            case MethodType.LINKED.rawValue:
                if presentable.dataLinked != nil {
                    let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/vn-mecorp-payme-wallet.appspot.com/o/image_bank%2Fimage_method%2Fmethod\(presentable.dataLinked!.swiftCode ?? presentable.dataLinked!.issuer).png?alt=media&token=28cdb30e-fa9b-430c-8c0e-5369f500612e")
                    DispatchQueue.global().async {
                        if let sureURL = url as URL? {
                            if let data = try? Data(contentsOf: sureURL) {
                                DispatchQueue.main.async {
                                    self.methodView.image.image = UIImage(data: data)
                                }
                            }
                        }
                    }
                }
                break
            case MethodType.BANK_CARD.rawValue:
                methodView.image.image = UIImage(for: Method.self, named: "iconAtm")
                break
            case MethodType.BANK_QR_CODE.rawValue:
                methodView.image.image = UIImage(for: Method.self, named: "iconQRBank")
            case MethodType.BANK_TRANSFER.rawValue:
                methodView.image.image = UIImage(for: Method.self, named: "iconBankTransfer")
            case MethodType.CREDIT_CARD.rawValue:
                methodView.image.image = UIImage(for: Method.self, named: "iconCreditCard")
            default:
                methodView.image.image = UIImage(for: Method.self, named: "iconWallet")
                break
            }
        }
        methodView.updateUI()
    }
}

