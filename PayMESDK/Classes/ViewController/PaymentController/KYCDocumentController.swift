//
//  KYCDocumentController.swift
//  PayMESDK
//
//  Created by HuyOpen on 11/24/20.
//

import UIKit

class KYCDocumentController: UINavigationController, PanModalPresentable, UITableViewDelegate,
  UITableViewDataSource
{
  public var data: [KYCDocument] = []
  public var active = 0
  private var onSuccessChoiceKYC: ((Int) -> Void)? = nil

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(closeButton)
    view.addSubview(txtLabel)
    view.addSubview(tableView)

    txtLabel.text = "choseDocument".localize()
    button.setTitle("confirm".localize(), for: .normal)
    setupConstraints()
    tableView.register(KYCMethod.self, forCellReuseIdentifier: "cell")
    tableView.delegate = self
    tableView.dataSource = self
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

  public func setOnSuccessChoiceKYC(onSuccessChoiceKYC: @escaping (Int) -> Void) {
    self.onSuccessChoiceKYC = onSuccessChoiceKYC
  }

  func setupConstraints() {
    txtLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 19).isActive = true
    txtLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    tableView.topAnchor.constraint(equalTo: txtLabel.bottomAnchor, constant: 10).isActive = true
    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 108.0
    tableView.alwaysBounceVertical = false

    closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
    closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive =
      true
    closeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    closeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
    closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
    view.safeAreaLayoutGuide.bottomAnchor.constraint(
      greaterThanOrEqualTo: tableView.bottomAnchor, constant: 10
    ).isActive = true
  }

  override func viewDidLayoutSubviews() {
    tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height).isActive = true
  }

  @objc func closeAction(button: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }

  let tableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.separatorStyle = .none
    return tableView
  }()

  let closeButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(for: KYCDocumentController.self, named: "16Px"), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
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

  func onSelectionRow(index: Int) {
    let temp = data
    for i in 0..<data.count {
      if i == index {
        temp[i].active = true
      } else {
        temp[i].active = false
      }
    }
    active = index
    data = temp
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    onSelectionRow(index: indexPath.row)
    tableView.reloadData()
    onSuccessChoiceKYC!(active)
    dismiss(animated: true, completion: nil)
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

extension KYCDocumentController {
  func numberOfSectionsInTableView(_tableView: UITableView) -> Int {
    return data.count
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? KYCMethod
    else {
      return UITableViewCell()
    }
    cell.configure(with: data[indexPath.row])

    return cell
  }
}
