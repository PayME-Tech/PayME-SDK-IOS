//
//  ResultView.swift
//  PayMESDK
//
//  Created by Minh Khoa on 5/4/21.
//

import Foundation
import Lottie
import RxSwift

class ResultView: UIView {
  public let resultSubject: PublishSubject<Result> = PublishSubject()
  private let disposeBag = DisposeBag()

  let animationView = LottieAnimationView()
  let screenSize: CGRect = UIScreen.main.bounds

  let containerView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = false
    return scrollView
  }()

  let topView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  let image: UIImageView = {
    var bgImage = UIImageView(image: UIImage(for: ResultView.self, named: "success"))
    bgImage.translatesAutoresizingMaskIntoConstraints = false
    return bgImage
  }()

  let nameLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor(24, 26, 65)
    label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
    label.backgroundColor = .clear
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  let roleLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = .clear
    label.font = UIFont.systemFont(ofSize: 36, weight: .semibold)
    label.lineBreakMode = .byWordWrapping
    label.numberOfLines = 0
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  let failLabel: UILabel = {
    let failLabel = UILabel()
    failLabel.textColor = UIColor(202, 15, 20)
    failLabel.backgroundColor = .clear
    failLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    failLabel.lineBreakMode = .byWordWrapping
    failLabel.numberOfLines = 0
    failLabel.textAlignment = .center
    failLabel.translatesAutoresizingMaskIntoConstraints = false

    return failLabel
  }()

  let button: UIButton = {
    let button = UIButton()
    button.backgroundColor = .clear
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.cornerRadius = 20
    return button
  }()

  let detailView: UIView = {
    let detailView = UIView()
    detailView.translatesAutoresizingMaskIntoConstraints = false
    detailView.layer.cornerRadius = 15
    return detailView
  }()

  init(type: Int = 0) {
    super.init(frame: CGRect.zero)
    setupUI()
  }

  func setupUI() {
    backgroundColor = UIColor(242, 244, 243)
    topView.backgroundColor = .white
    detailView.backgroundColor = .white

    containerView.bounces = false

    addSubview(topView)
    addSubview(containerView)
    addSubview(button)

    containerView.addSubview(detailView)

    topView.addSubview(animationView)
    topView.addSubview(nameLabel)
    topView.addSubview(roleLabel)
    topView.addSubview(failLabel)

    topView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    topView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    topView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

    animationView.translatesAutoresizingMaskIntoConstraints = false
    animationView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 8).isActive = true
    animationView.heightAnchor.constraint(equalToConstant: 118).isActive = true
    animationView.widthAnchor.constraint(equalToConstant: 111).isActive = true
    animationView.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
    animationView.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)

    nameLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
    nameLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor).isActive = true

    roleLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
    roleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
    roleLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -30).isActive =
      true
    roleLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 30).isActive = true

    failLabel.topAnchor.constraint(equalTo: roleLabel.bottomAnchor, constant: 4.0).isActive = true
    failLabel.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -30).isActive =
      true
    failLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 30).isActive = true
    failLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
    topView.bottomAnchor.constraint(equalTo: failLabel.bottomAnchor, constant: 18).isActive = true

    containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    containerView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
    //detailView - bottomView
    detailView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
    detailView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
    detailView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true

    //methodView
    button.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 12).isActive = true
    button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    button.heightAnchor.constraint(equalToConstant: 45).isActive = true
    button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true

    bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 4).isActive = true
    button.setTitle("Hoàn tất", for: .normal)
  }

  func adaptView(result: Result) {
    nameLabel.text = result.titleLabel
    roleLabel.text = "\(formatMoney(input: result.orderTransaction.total)) đ"

    let bundle = Bundle(for: ResultView.self)
    let bundleURL = bundle.resourceURL?.appendingPathComponent("PayMESDK.bundle")
    let resourceBundle = Bundle(url: bundleURL!)
    switch result.type! {
    case ResultType.SUCCESS:
      failLabel.isHidden = true
      roleLabel.textColor = UIColor(hexString: PayME.configColor[0])
      let animation = LottieAnimation.named("Result_Thanh_Cong", bundle: resourceBundle!)
      animationView.animation = animation
      animationView.contentMode = .scaleAspectFit
      animationView.loopMode = .loop

      let color = ColorValueProvider(UIColor(hexString: PayME.configColor[0]).lottieColorValue)
      let keyPathLL = AnimationKeypath(keypath: "Laplanh.**.Fill 1.Color")
      let keyPathDO = AnimationKeypath(keypath: "Do.**.Fill 1.Color")
      animationView.setValueProvider(color, keypath: keyPathLL)
      animationView.setValueProvider(color, keypath: keyPathDO)

      button.setTitle("finishLowerCase".localize(), for: .normal)
      break
    case ResultType.PENDING:
      roleLabel.textColor = UIColor(0, 0, 0)
      failLabel.text = result.failReasonLabel
      let animation = LottieAnimation.named("Result_Cho_xu_ly", bundle: resourceBundle!)
      animationView.animation = animation
      animationView.contentMode = .scaleAspectFit
      animationView.loopMode = .loop
      button.setTitle("understood".localize(), for: .normal)
      break
    default:
      roleLabel.textColor = UIColor(0, 0, 0)
      failLabel.text = result.failReasonLabel
      let animation = LottieAnimation.named("Result_That_Bai", bundle: resourceBundle!)
      animationView.animation = animation
      animationView.contentMode = .scaleAspectFit
      animationView.loopMode = .loop
      button.setTitle("understood".localize(), for: .normal)
    }

    if result.type == ResultType.SUCCESS || result.type == ResultType.PENDING {
      var paymentView: InformationView
      switch result.orderTransaction.paymentMethod?.type {
      case MethodType.WALLET.rawValue:
        paymentView = InformationView(data: [
          ["key": "transactionCode".localize(), "value": result.transactionInfo.transaction],
          ["key": "transactionTime".localize(), "value": result.transactionInfo.transactionTime],
          ["key": "method".localize(), "value": "walletBalance".localize()],
        ])
        break
      case MethodType.LINKED.rawValue:
        paymentView = InformationView(data: [
          ["key": "transactionCode".localize(), "value": result.transactionInfo.transaction],
          ["key": "transactionTime".localize(), "value": result.transactionInfo.transactionTime],
          ["key": "method".localize(), "value": "linkedAccount".localize()],
          [
            "key": "accountNumber".localize(),
            "value":
              "\(String(describing: result.orderTransaction.paymentMethod?.title ?? ""))-\(String(describing: result.orderTransaction.paymentMethod!.label.suffix(4)))",
          ],
        ])
        break
      case MethodType.CREDIT_BALANCE.rawValue:
        paymentView = InformationView(data: [
          ["key": "transactionCode".localize(), "value": result.transactionInfo.transaction],
          ["key": "transactionTime".localize(), "value": result.transactionInfo.transactionTime],
          ["key": "method".localize(), "value": "creditWallet".localize()],
        ])
        break
      case MethodType.BANK_CARD.rawValue:
        paymentView = InformationView(data: [
          ["key": "transactionCode".localize(), "value": result.transactionInfo.transaction],
          ["key": "transactionTime".localize(), "value": result.transactionInfo.transactionTime],
          ["key": "method".localize(), "value": "bankCard".localize()],
          [
            "key": "cardNumber".localize(),
            "value":
              "\(String(describing: result.orderTransaction.paymentMethod?.dataBank?.bank?.shortName ?? ""))-\(String(describing: result.orderTransaction.paymentMethod?.dataBank?.cardNumber.suffix(4) ?? ""))",
          ],
        ])
      case MethodType.BANK_TRANSFER.rawValue:
        paymentView = InformationView(data: [
          ["key": "transactionCode".localize(), "value": result.transactionInfo.transaction],
          ["key": "transactionTime".localize(), "value": result.transactionInfo.transactionTime],
          ["key": "method".localize(), "value": "bankTransfer".localize()],
        ])
      case MethodType.CREDIT_CARD.rawValue:
        paymentView = InformationView(data: [
          ["key": "transactionCode".localize(), "value": result.transactionInfo.transaction],
          ["key": "transactionTime".localize(), "value": result.transactionInfo.transactionTime],
          ["key": "method".localize(), "value": "creditCard".localize()],
          [
            "key": "cardNumber".localize(),
            "value":
              "\(String(describing: result.orderTransaction.paymentMethod?.dataCreditCard?.issuer ?? ""))-\(String(describing: result.orderTransaction.paymentMethod?.dataCreditCard?.cardNumber.suffix(4) ?? ""))",
          ],
        ])
      case MethodType.BANK_QR_CODE_PG.rawValue:
        paymentView = InformationView(data: [
          ["key": "transactionCode".localize(), "value": result.transactionInfo.transaction],
          ["key": "transactionTime".localize(), "value": result.transactionInfo.transactionTime],
          ["key": "method".localize(), "value": "qrPay".localize()],
        ])
      case MethodType.VIET_QR.rawValue:
        paymentView = InformationView(data: [
          ["key": "transactionCode".localize(), "value": result.transactionInfo.transaction],
          ["key": "transactionTime".localize(), "value": result.transactionInfo.transactionTime],
          ["key": "method".localize(), "value": "vietQR".localize()],
        ])
      default:
        paymentView = InformationView(data: [
          ["key": "transactionCode".localize(), "value": result.transactionInfo.transaction],
          ["key": "transactionTime".localize(), "value": result.transactionInfo.transactionTime],
        ])
        break
      }

      detailView.addSubview(paymentView)
      paymentView.topAnchor.constraint(equalTo: detailView.topAnchor).isActive = true
      paymentView.leadingAnchor.constraint(equalTo: detailView.leadingAnchor).isActive = true
      paymentView.trailingAnchor.constraint(equalTo: detailView.trailingAnchor).isActive = true

      let serviceView = InformationView(data: [
        ["key": "receiveName".localize(), "value": "\(result.orderTransaction.storeName)"],
        ["key": "content".localize(), "value": result.orderTransaction.note],
      ])
      detailView.addSubview(serviceView)
      serviceView.topAnchor.constraint(equalTo: paymentView.bottomAnchor, constant: 12).isActive =
        true
      serviceView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
      serviceView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    } else {
      let paymentView = InformationView(data: [
        ["key": "transactionCode".localize(), "value": result.transactionInfo.transaction],
        ["key": "transactionTime".localize(), "value": result.transactionInfo.transactionTime],
      ])
      detailView.addSubview(paymentView)
      paymentView.topAnchor.constraint(equalTo: detailView.topAnchor).isActive = true
      paymentView.leadingAnchor.constraint(equalTo: detailView.leadingAnchor).isActive = true
      paymentView.trailingAnchor.constraint(equalTo: detailView.trailingAnchor).isActive = true
      if result.transactionInfo.transaction.count > 0
        && result.transactionInfo.transactionTime.count > 0
      {
        paymentView.isHidden = false
      } else {
        paymentView.isHidden = true
      }
      let serviceView = InformationView(data: [
        ["key": "service".localize(), "value": "\(result.orderTransaction.storeName)"],
        ["key": "content".localize(), "value": result.orderTransaction.note],
      ])
      detailView.addSubview(serviceView)
      serviceView.topAnchor.constraint(equalTo: paymentView.bottomAnchor, constant: 12).isActive =
        true
      serviceView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
      serviceView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    }
    updateConstraints()
    layoutIfNeeded()

    let contentRect: CGRect = detailView.subviews.reduce(into: .zero) { rect, view in
      rect = rect.union(view.frame)
    }

    containerView.contentSize = contentRect.size
    //total top margin: 20
    containerView.contentSize.height = contentRect.size.height + 20
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
