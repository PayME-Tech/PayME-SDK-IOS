import CryptoSwift
import PayMESDK
import Sentry
import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  var floatingButtonController: FloatingButtonController = .init()
  var payME: PayME?
  var activeTextField: UITextField? = nil
  //    let envData: Dictionary = ["dev": PayME.Env.DEV,"sandbox": PayME.Env.SANDBOX]
  let envData: Dictionary = [
    "sandbox": PayME.Env.SANDBOX, "dev": PayME.Env.DEV, "production": PayME.Env.PRODUCTION,
  ]
  let langData = [PayME.Language.VIETNAMESE, PayME.Language.ENGLISH]
  let payCodeData = ["PAYME", "ATM", "CREDIT", "MOMO", "ZALO_PAY", "MANUAL_BANK", "VIET_QR"]

  let environment: UILabel = {
    let label = UILabel()
    label.font = label.font.withSize(16)
    label.backgroundColor = .clear
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Environment"
    return label
  }()

  let dropDown: UIButton = {
    let button = UIButton()
    button.layer.borderColor = UIColor.black.cgColor
    button.layer.borderWidth = 0.5
    button.setTitleColor(UIColor.black, for: .normal)
    button.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  let envList: UIPickerView = {
    let list = UIPickerView()
    list.layer.borderColor = UIColor.black.cgColor
    list.layer.borderWidth = 0.5
    list.backgroundColor = .white
    list.translatesAutoresizingMaskIntoConstraints = false
    return list
  }()

  let langLabel: UILabel = {
    let label = UILabel()
    label.font = label.font.withSize(16)
    label.backgroundColor = .clear
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Language"
    return label
  }()

  let langDropDown: UIButton = {
    let button = UIButton()
    button.layer.borderColor = UIColor.black.cgColor
    button.layer.borderWidth = 0.5
    button.setTitleColor(UIColor.black, for: .normal)
    button.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  let langList: UIPickerView = {
    let list = UIPickerView()
    list.layer.borderColor = UIColor.black.cgColor
    list.layer.borderWidth = 0.5
    list.backgroundColor = .white
    list.translatesAutoresizingMaskIntoConstraints = false
    return list
  }()

  let payCodeLabel: UILabel = {
    let label = UILabel()
    label.font = label.font.withSize(14)
    label.backgroundColor = .clear
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Pay Code"
    return label
  }()

  let payCodeDropDown: UIButton = {
    let button = UIButton()
    button.layer.borderColor = UIColor.black.cgColor
    button.layer.borderWidth = 0.5
    button.backgroundColor = .white
    button.setTitleColor(UIColor.black, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  let payCodeList: UIPickerView = {
    let list = UIPickerView()
    list.layer.borderColor = UIColor.black.cgColor
    list.layer.borderWidth = 0.5
    list.backgroundColor = .white
    list.translatesAutoresizingMaskIntoConstraints = false
    return list
  }()

  let settingButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "setting.svg"), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  let userIDLabel: UILabel = {
    let label = UILabel()
    label.font = label.font.withSize(16)
    label.backgroundColor = .clear
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "UserID"
    return label
  }()

  let userIDTextField: UITextField = {
    let textField = UITextField()
    textField.layer.borderColor = UIColor.black.cgColor
    textField.layer.borderWidth = 0.5
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.setLeftPaddingPoints(10)
    textField.keyboardType = .numberPad
    return textField
  }()

  let phoneLabel: UILabel = {
    let label = UILabel()
    label.font = label.font.withSize(16)
    label.backgroundColor = .clear
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Phone number"
    return label
  }()

  let phoneTextField: UITextField = {
    let textField = UITextField()
    textField.layer.borderColor = UIColor.black.cgColor
    textField.layer.borderWidth = 0.5
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.setLeftPaddingPoints(10)
    textField.placeholder = "Optional"
    textField.keyboardType = .numberPad
    return textField
  }()

  let loginButton: UIButton = {
    let button = UIButton()
    button.layer.borderColor = UIColor.black.cgColor
    button.layer.borderWidth = 0.5
    button.layer.cornerRadius = 15
    button.setTitle("Login", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  let logoutButton: UIButton = {
    let button = UIButton()
    button.layer.borderColor = UIColor.black.cgColor
    button.layer.borderWidth = 0.5
    button.layer.cornerRadius = 15
    button.setTitle("Logout", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.backgroundColor = .lightGray
    scrollView.isScrollEnabled = true
    scrollView.alwaysBounceVertical = false
    scrollView.isHidden = true
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    return scrollView
  }()

  let sdkContainer: UIView = {
    let container = UIView()
    container.translatesAutoresizingMaskIntoConstraints = false
    return container
  }()

  let balance: UILabel = {
    let label = UILabel()
    label.font = label.font.withSize(14)
    label.backgroundColor = .clear
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Balance"
    return label
  }()

  let priceLabel: UILabel = {
    let label = UILabel()
    label.font = label.font.withSize(16)
    label.backgroundColor = .clear
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "0"
    return label
  }()

  let refreshButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(named: "refresh.png"), for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  let openWalletButton: UIButton = {
    let button = UIButton()
    button.layer.borderColor = UIColor.black.cgColor
    button.layer.borderWidth = 0.5
    button.layer.cornerRadius = 10
    button.backgroundColor = UIColor.white
    button.setTitle("Open Wallet", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  let getQuotaButton: UIButton = {
    let button = UIButton()
    button.layer.borderColor = UIColor.black.cgColor
    button.layer.borderWidth = 0.5
    button.layer.cornerRadius = 10
    button.backgroundColor = UIColor.white
    button.setTitle("Kiểm tra hạn mức giao dịch", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  let openHistoryButton: UIButton = {
    let button = UIButton()
    button.layer.borderColor = UIColor.black.cgColor
    button.layer.borderWidth = 0.5
    button.layer.cornerRadius = 10
    button.backgroundColor = UIColor.white
    button.setTitle("Open History", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  let userNameField: UITextField = {
    let textField = UITextField()
    textField.layer.borderColor = UIColor.black.cgColor
    textField.layer.borderWidth = 0.5
    textField.backgroundColor = UIColor.white
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = "Nhập username"
    textField.text = ""
    textField.setLeftPaddingPoints(10)
    return textField
  }()

  let depositButton: UIButton = {
    let button = UIButton()
    button.layer.borderColor = UIColor.black.cgColor
    button.layer.borderWidth = 0.5
    button.layer.cornerRadius = 10
    button.backgroundColor = UIColor.white
    button.setTitle("Nạp tiền ví", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 15)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  let moneyDeposit: UITextField = {
    let textField = UITextField()
    textField.layer.borderColor = UIColor.black.cgColor
    textField.layer.borderWidth = 0.5
    textField.backgroundColor = UIColor.white
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = "Nhập số tiền"
    textField.text = "10000"
    textField.setLeftPaddingPoints(10)
    textField.keyboardType = .numberPad
    return textField
  }()

  let serviceButton: UIButton = {
    let button = UIButton()
    button.layer.borderColor = UIColor.black.cgColor
    button.layer.borderWidth = 0.5
    button.layer.cornerRadius = 10
    button.backgroundColor = UIColor.white
    button.setTitle("Mở dịch vụ", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 15)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  let serviceText: UITextField = {
    let textField = UITextField()
    textField.layer.borderColor = UIColor.black.cgColor
    textField.layer.borderWidth = 0.5
    textField.backgroundColor = UIColor.white
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = "Nhập service"
    textField.text = "WATE"
    textField.setLeftPaddingPoints(10)
    textField.keyboardType = .numberPad
    return textField
  }()

  let withDrawButton: UIButton = {
    let button = UIButton()
    button.layer.borderColor = UIColor.black.cgColor
    button.layer.borderWidth = 0.5
    button.layer.cornerRadius = 10
    button.backgroundColor = UIColor.white
    button.setTitle("Rút tiền ví", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 15)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  let moneyWithDraw: UITextField = {
    let textField = UITextField()
    textField.layer.borderColor = UIColor.black.cgColor
    textField.layer.borderWidth = 0.5
    textField.backgroundColor = UIColor.white
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = "Nhập số tiền"
    textField.text = "10000"
    textField.setLeftPaddingPoints(10)
    textField.keyboardType = .numberPad
    return textField
  }()

  let payButton: UIButton = {
    let button = UIButton()
    button.layer.borderColor = UIColor.black.cgColor
    button.layer.borderWidth = 0.5
    button.layer.cornerRadius = 10
    button.backgroundColor = UIColor.white
    button.setTitle("Thanh toán", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 15)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  let moneyPay: UITextField = {
    let textField = UITextField()
    textField.layer.borderColor = UIColor.black.cgColor
    textField.layer.borderWidth = 0.5
    textField.backgroundColor = UIColor.white
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = "Nhập số tiền"
    textField.text = "10000"
    textField.setLeftPaddingPoints(10)
    textField.keyboardType = .numberPad
    return textField
  }()

  let qrPayString: UITextField = {
    let textField = UITextField()
    textField.layer.borderColor = UIColor.black.cgColor
    textField.layer.borderWidth = 0.5
    textField.backgroundColor = UIColor.white
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = "Nhập QR"
    textField.text =
      "00020101021238600010A00000072701300006970400011697040000000000180208QRIBFTTA5303704540750000005802VN62120808Xin chao6304857B"
    textField.setLeftPaddingPoints(10)
    return textField
  }()

  let qrPayButton: UIButton = {
    let button = UIButton()
    button.layer.borderColor = UIColor.black.cgColor
    button.layer.borderWidth = 0.5
    button.layer.cornerRadius = 10
    button.backgroundColor = UIColor.white
    button.setTitle("Pay QR", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 15)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  let transferButton: UIButton = {
    let button = UIButton()
    button.layer.borderColor = UIColor.black.cgColor
    button.layer.borderWidth = 0.5
    button.layer.cornerRadius = 10
    button.backgroundColor = UIColor.white
    button.setTitle("Chuyển", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 15)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  let moneyTransfer: UITextField = {
    let textField = UITextField()
    textField.layer.borderColor = UIColor.black.cgColor
    textField.layer.borderWidth = 0.5
    textField.backgroundColor = UIColor.white
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = "Nhập số tiền"
    textField.text = "10000"
    textField.setLeftPaddingPoints(10)
    textField.keyboardType = .numberPad
    return textField
  }()

  let getMethodButton: UIButton = {
    let button = UIButton()
    button.layer.borderColor = UIColor.black.cgColor
    button.layer.borderWidth = 0.5
    button.layer.cornerRadius = 10
    button.backgroundColor = UIColor.white
    button.setTitle("Lấy danh sách ID phương thức", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 15)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  let scanQRButton: UIButton = {
    let button = UIButton()
    button.layer.borderColor = UIColor.black.cgColor
    button.layer.borderWidth = 0.5
    button.layer.cornerRadius = 10
    button.backgroundColor = UIColor.white
    button.setTitle("Quét QR", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 15)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  let getServiceButton: UIButton = {
    let button = UIButton()
    button.layer.borderColor = UIColor.black.cgColor
    button.layer.borderWidth = 0.5
    button.layer.cornerRadius = 10
    button.backgroundColor = UIColor.white
    button.setTitle("Lấy danh sách dịch vụ", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 15)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  let kycButton: UIButton = {
    let button = UIButton()
    button.layer.borderColor = UIColor.black.cgColor
    button.layer.borderWidth = 0.5
    button.layer.cornerRadius = 10
    button.backgroundColor = UIColor.white
    button.setTitle("Định danh tài khoản", for: .normal)
    button.setTitleColor(UIColor.black, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 15)
    button.isHidden = true
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  private var connectToken: String = ""
  private var currentEnv: PayME.Env = .SANDBOX
  private var curLanguage: String = PayME.Language.VIETNAMESE
  private var curPayCode: String = "PAYME"

  func genConnectToken(userId: String, phone: String) -> String {
    let secretKey = EnvironmentSettings.standard.secretKey
    Log.custom.push(title: "Secret key login", message: secretKey)
    let iSO8601DateFormatter = ISO8601DateFormatter()
    let isoDate = iSO8601DateFormatter.string(from: Date())
    let data: [String: Any] = [
      "timestamp": isoDate, "userId": "\(userId)", "phone": "\(phone)",
        //            "kycInfo": [
        //                "fullname": "Lai Van Hieu",
        //                "gender": "MALE",
        //                "birthday": "1995-01-20T06:53:07.621Z",
        //                "address": "31 vu tung",
        //                "identifyType": "CMND",
        //                "identifyNumber": "String",
        //                "issuedAt": "2012-01-20T06:53:07.621Z",
        //                "placeOfIssue":"Hai Duong",
        //                "video": "https://sbx-static.payme.vn//2020/10/28/Co-29vnK6.mp4",
        //                "face":"https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
        //                "image": [
        //                    "front": "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
        //                    "back":"https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg"
        //                ]
        //            ]
    ]
    let params = try? JSONSerialization.data(withJSONObject: data)
    let aes = try? AES(
      key: Array(secretKey.utf8), blockMode: CBC(iv: [UInt8](repeating: 0, count: 16)),
      padding: .pkcs5)
    let dataEncrypted = try? aes?.encrypt(Array(String(data: params!, encoding: .utf8)!.utf8))
    return dataEncrypted?.toBase64() ?? ""
  }

  // generate token ( demo, don't apply this to your code, generate from your server)
  @objc func submit() {
    // PayME.showKYCCamera(currentVC: self)
    // Getting
    UserDefaults.standard.set(userIDTextField.text, forKey: "userID")
    UserDefaults.standard.set(phoneTextField.text, forKey: "phone")
    if userIDTextField.text != "" {
      let newConnectToken = self.genConnectToken(
        userId: userIDTextField.text!, phone: phoneTextField.text!)
      Log.custom.push(title: "Connect Token Generator", message: newConnectToken)
      self.connectToken = newConnectToken
      Log.custom.push(
        title: "Environment variables",
        message: """
          {
          appToken: \(EnvironmentSettings.standard.appToken),
          publicKey: \(EnvironmentSettings.standard.publicKey),
          connectToken: \(self.connectToken),
          appPrivateKey: \(EnvironmentSettings.standard.privateKey),
          env: \(self.currentEnv)
          }
          """)
      payME = PayME(
        appToken: EnvironmentSettings.standard.appToken,
        publicKey: EnvironmentSettings.standard.publicKey,
        connectToken: self.connectToken,
        appPrivateKey: EnvironmentSettings.standard.privateKey,
        language: curLanguage,
        env: currentEnv,
        configColor: ["#6756d6", "#4430b3"],
        showLog: 1
      )
      showSpinner(onView: view)
      payME?.login(
        onSuccess: { _ in
          self.scrollView.isHidden = false
          //                if success["code"] as! PayME.KYCState == PayME.KYCState.NOT_KYC {
          self.kycButton.isHidden = false
          //                }
          self.getBalance(self.refreshButton)
          self.loginButton.backgroundColor = UIColor.gray
          self.logoutButton.backgroundColor = UIColor.white
          self.removeSpinner()
        },
        onError: { error in
          self.scrollView.isHidden = true
          self.removeSpinner()
          self.toastMess(
            title: "Lỗi", value: (error["message"] as? String) ?? "Something went wrong")
        })
    } else {
      let alert = UIAlertController(
        title: "Success", message: "Vui lòng nhập userID",
        preferredStyle: UIAlertController.Style.alert)
      alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
      present(alert, animated: true, completion: nil)
    }
  }

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if pickerView == envList {
      return envData.count
    }
    if pickerView == payCodeList {
      return payCodeData.count
    }
    return langData.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)
    -> String?
  {
    if pickerView == envList {
      return Array(envData.keys)[row]
    }
    if pickerView == payCodeList {
      return payCodeData[row]
    }
    return langData[row]
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if pickerView == envList {
      setEnv(env: envData[Array(envData.keys)[row]], text: Array(envData.keys)[row])
    } else if pickerView == payCodeList {
      setPayCode(payCodeData[row])
    } else {
      setLang(lang: langData[row])
    }
    pickerView.isHidden = true
  }

  @objc func logout(sender: UIButton!) {
    payME?.logout()
    scrollView.isHidden = true
    loginButton.backgroundColor = UIColor.white
    logoutButton.backgroundColor = UIColor.gray
  }

  @objc func onGetQuota() {
    payME!.getRemainingQuota(
      onSuccess: { value in
        self.toastMess(title: "Hạn mức còn lại", value: String(describing: value))
      },
      onError: { error in
        Log.custom.push(title: "Open wallet", message: error)
        if let code = error["code"] as? Int {
          if code != PayME.ResponseCode.USER_CANCELLED {
            let message = error["message"] as? String
            self.toastMess(title: "Lỗi", value: message)
          }
        }
      })
  }

  @objc func openWalletAction(sender: UIButton!) {
    if self.connectToken != "" {
      payME!.openWallet(
        currentVC: self, action: PayME.Action.OPEN, amount: nil, description: nil, extraData: nil,
        onSuccess: { success in
          Log.custom.push(title: "Open wallet", message: success)
        },
        onError: { error in
          Log.custom.push(title: "Open wallet", message: error)
          if let code = error["code"] as? Int {
            if code != PayME.ResponseCode.USER_CANCELLED {
              let message = error["message"] as? String
              self.toastMess(title: "Lỗi", value: message)
            }
          }
        })
    } else {
      toastMess(title: "Lỗi", value: "Vui lòng tạo connect token trước")
    }
  }

  @objc func openHistoryAction(sender: UIButton!) {
    if self.connectToken != "" {
      payME!.openHistory(
        currentVC: self,
        onSuccess: { success in
          Log.custom.push(title: "Open history", message: success)
        },
        onError: { error in
          Log.custom.push(title: "Open history", message: error)
          if let code = error["code"] as? Int {
            if code != PayME.ResponseCode.USER_CANCELLED {
              let message = error["message"] as? String
              self.toastMess(title: "Lỗi", value: message)
            }
          }
        })
    } else {
      toastMess(title: "Lỗi", value: "Vui lòng tạo connect token trước")
    }
  }

  @objc func depositAction(sender: UIButton!) {
    if self.connectToken != "" {
      if moneyDeposit.text != "" {
        let amount = Int(moneyDeposit.text!)
        if amount! >= 10000 {
          let amountDeposit = amount!
          self.payME!.deposit(
            currentVC: self, amount: amountDeposit, description: "", extraData: nil,
            closeWhenDone: true,
            onSuccess: { success in
              Log.custom.push(title: "deposit", message: success)
            },
            onError: { error in
              Log.custom.push(title: "deposit", message: error)
              if let code = error["code"] as? Int {
                if code != PayME.ResponseCode.USER_CANCELLED {
                  let message = error["message"] as? String
                  self.toastMess(title: "Lỗi", value: message)
                }
              }
            })

        } else {
          toastMess(title: "Lỗi", value: "Vui lòng nạp hơn 10.000VND")
        }
      } else {
        toastMess(title: "Lỗi", value: "Vui lòng nạp hơn 10.000VND")
      }
    } else {
      toastMess(title: "Lỗi", value: "Vui lòng tạo connect token trước")
    }
  }

  @objc func serviceAction(sender: UIButton!) {
    if self.connectToken != "" {
      if serviceText.text != "" {
        let service = serviceText.text
        self.payME!.openService(
          currentVC: self, amount: nil, description: nil, extraData: nil,
          service: ServiceConfig(service!, ""),
          onSuccess: { success in
            Log.custom.push(title: "open Service", message: success)
          },
          onError: { error in
            Log.custom.push(title: "openService", message: error)
            if let code = error["code"] as? Int {
              if code != PayME.ResponseCode.USER_CANCELLED {
                let message = error["message"] as? String
                self.toastMess(title: "Lỗi", value: message)
              }
            }
          })
      } else {
        toastMess(title: "Lỗi", value: "Nhập service")
      }
    } else {
      toastMess(title: "Lỗi", value: "Vui lòng tạo connect token trước")
    }
  }

  @objc func withDrawAction(sender: UIButton!) {
    if connectToken != "" {
      if moneyWithDraw.text != "" {
        let amount = Int(moneyWithDraw.text!)
        if amount! >= 10000 {
          let amountWithDraw = amount!
          payME!.withdraw(
            currentVC: self, amount: amountWithDraw, description: "", extraData: nil,
            onSuccess: { success in
              Log.custom.push(title: "withdraw", message: success)

            },
            onError: { error in
              Log.custom.push(title: "withdraw", message: error)
              if let code = error["code"] as? Int {
                if code != PayME.ResponseCode.USER_CANCELLED {
                  let message = error["message"] as? String
                  self.toastMess(title: "Lỗi", value: message)
                }
              }
            })
        } else {
          toastMess(title: "Lỗi", value: "Vui lòng rút hơn 10.000VND")
        }
      } else {
        toastMess(title: "Lỗi", value: "Vui lòng rút hơn 10.000VND")
      }
    } else {
      toastMess(title: "Lỗi", value: "Vui lòng tạo connect token trước")
    }
  }

  @objc func transferAction(sender: UIButton!) {
    if connectToken != "" {
      if moneyWithDraw.text != "" {
        let amount = Int(moneyWithDraw.text!)
        if amount! >= 10000 {
          let amountWithDraw = amount!
          payME!.transfer(
            currentVC: self, amount: amountWithDraw, description: "", extraData: nil,
            closeWhenDone: true,
            onSuccess: { success in
              Log.custom.push(title: "withdraw", message: success)
            },
            onError: { error in
              Log.custom.push(title: "withdraw", message: error)
              if let code = error["code"] as? Int {
                if code != PayME.ResponseCode.USER_CANCELLED {
                  let message = error["message"] as? String
                  self.toastMess(title: "Lỗi", value: message)
                }
              }
            })
        } else {
          toastMess(title: "Lỗi", value: "Vui lòng chuyển hơn 10.000VND")
        }
      } else {
        toastMess(title: "Lỗi", value: "Vui lòng chuyển hơn 10.000VND")
      }
    } else {
      toastMess(title: "Lỗi", value: "Vui lòng tạo connect token trước")
    }
  }

  @objc func onPayQR(sender: UIButton!) {
    if connectToken != "" {
      if qrPayString.text != "" {
        payME!.payQRCode(
          currentVC: self, qr: qrPayString.text!, payCode: curPayCode, isShowResultUI: false,
          onSuccess: { success in
            Log.custom.push(title: "payQRCode Success", message: success)
          },
          onError: { error in
            Log.custom.push(title: "payQRCode Error", message: error)
            if let code = error["code"] as? Int {
              if code != PayME.ResponseCode.USER_CANCELLED {
                let message = error["message"] as? String
                self.toastMess(title: "Lỗi", value: message)
              }
            }
          })
      } else {
        toastMess(title: "Lỗi", value: "Vui lòng nhập mã QR")
      }
    } else {
      toastMess(title: "Lỗi", value: "Vui lòng tạo connect token trước")
    }
  }

  @objc func getListService() {
    payME!.getSupportedServices(
      onSuccess: { configs in
        var serviceList = ""
        configs.forEach { service in
          serviceList += "[Key: \(service.getCode()) - Name: \(service.getDescription())]"
        }
        self.toastMess(title: "Lấy danh sách dịch vụ thành công", value: "\(serviceList)")
      },
      onError: { error in
        let message = error["message"] as? String
        self.toastMess(title: "Lỗi", value: message)
      })
  }

  @objc func scanQR() {
    payME!.scanQR(
      currentVC: self, payCode: curPayCode,
      onSuccess: { response in
        Log.custom.push(title: "payQRCode Success", message: response)
      },
      onError: { error in
        Log.custom.push(title: "payQRCode Error", message: error)
        if let code = error["code"] as? Int {
          if code != PayME.ResponseCode.USER_CANCELLED {
            let message = error["message"] as? String
            self.toastMess(title: "Lỗi", value: message)
          }
        }
      })
  }

  @objc func onKYC() {
    payME!.openKYC(
      currentVC: self, onSuccess: {},
      onError: { dictionary in
        let message = dictionary["message"] as? String
        self.toastMess(title: "Lỗi", value: message)
      })
  }

  @objc func payAction(sender: UIButton!) {
    if self.connectToken != "" {
      if moneyPay.text != "" {
        let amount = Int(moneyPay.text!)
        let amountPay = amount!
        _ = "paymesdk://\(Bundle.main.bundleIdentifier ?? "")/success"
        payME!.pay(
          currentVC: self, storeId: nil, userName: userNameField.text,
          orderId: String(Date().timeIntervalSince1970), amount: amountPay,
          note: "Nội dung đơn hàng", payCode: curPayCode, extraData: nil, isShowResultUI: true,
          onSuccess: { success in
            Log.custom.push(title: "pay", message: success)
          },
          onError: { error in
            Log.custom.push(title: "pay", message: error)
            if let code = error["code"] as? Int {
              if code != PayME.ResponseCode.USER_CANCELLED {
                let message = error["message"] as? String
                self.toastMess(title: "Lỗi", value: message)
              }
            }
          })
      } else {
        toastMess(title: "Lỗi", value: "Vui lòng nhập số tiền")
      }

    } else {
      toastMess(title: "Lỗi", value: "Vui lòng tạo connect token trước")
    }
  }

  @IBAction func getBalance(_ sender: Any) {
    if self.connectToken != "" {
      payME!.getWalletInfo(
        onSuccess: { a in
          self.removeSpinner()
          Log.custom.push(title: "get Wallet Info", message: a)
          var str = ""
          if let v = a["Wallet"]!["balance"]! {
            str = "\(v)"
          }
          let alert = UIAlertController(
            title: "Thành công", message: "Lấy balance thành công",
            preferredStyle: UIAlertController.Style.alert)
          alert.addAction(
            UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
          self.present(
            alert, animated: true,
            completion: {
              self.priceLabel.text = str
            })
        },
        onError: { error in
          self.removeSpinner()
          Log.custom.push(title: "get Wallet Info", message: error)
          let message = error["message"] as? String
          self.priceLabel.text = "0"
          self.toastMess(title: "Lỗi", value: message)
        })
    } else {
      self.removeSpinner()
      toastMess(title: "Lỗi", value: "Vui lòng tạo connect token trước")
    }
  }

  func textField(
    _ textField: UITextField, shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    // For mobile numer validation
    if textField == phoneTextField || textField == moneyDeposit || textField == moneyWithDraw
      || textField == moneyPay || textField == moneyTransfer
    {
      let allowedCharacters = CharacterSet(charactersIn: "+0123456789 ")  // Here change this characters based on your requirement
      let characterSet = CharacterSet(charactersIn: string)
      let maxLength = 11
      let currentString: NSString = (textField.text ?? "") as NSString
      let newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
      return allowedCharacters.isSuperset(of: characterSet) && newString.length <= maxLength
    }
    return true
  }

  @objc func keyboardWillShow(notification: NSNotification) {
    guard
      let keyboardSize =
        (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    else {
      // if keyboard size is not available for some reason, dont do anything
      return
    }

    var shouldMoveViewUp = false

    // if active text field is not nil
    if let activeTextField = activeTextField {
      let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY

      let topOfKeyboard = self.view.frame.height - keyboardSize.height
      // if the bottom of Textfield is below the top of keyboard, move up
      if bottomOfTextField > topOfKeyboard - 50 {
        shouldMoveViewUp = true
      }
    }
    if shouldMoveViewUp {
      self.view.frame.origin.y = 0 - keyboardSize.height
    }
  }

  @objc func keyboardWillHide(notification: NSNotification) {
    // move back the root view origin to zero
    self.view.frame.origin.y = 0
  }

  @IBAction func onPressSetting(_ sender: UIButton) {
    let vc = SettingsView()
    navigationController?.pushViewController(vc, animated: true)
  }

  @IBAction func onPressDropDown(_ sender: UIButton) {
    self.envList.isHidden = !self.envList.isHidden
  }

  @objc func onPressLangDropDown() {
    langList.isHidden = !langList.isHidden
  }

  @objc func onPressPayCodeDropDown() {
    payCodeList.isHidden = !payCodeList.isHidden
  }

  func setEnv(env: PayME.Env!, text: String!) {
    EnvironmentSettings.standard.changeEnvironment(env: text)
    UserDefaults.standard.set(text, forKey: "env")
    self.dropDown.setTitle(text, for: .normal)
    self.currentEnv = env
    self.logout(sender: logoutButton)
  }

  func setLang(lang: String) {
    payME?.setLanguage(language: lang)
    curLanguage = lang
    langDropDown.setTitle(lang, for: .normal)
  }

  func setPayCode(_ payCode: String) {
    curPayCode = payCode
    payCodeDropDown.setTitle(payCode, for: .normal)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = false
    let isShowLog = UserDefaults.standard.bool(forKey: "isShowLog")
    if isShowLog {
      self.floatingButtonController.showWindow()
    } else {
      self.floatingButtonController.hideWindow()
    }
  }

  func toastMess(title: String, value: String?) {
    let alert = UIAlertController(
      title: title, message: value ?? "Có lỗi xảy ra", preferredStyle: UIAlertController.Style.alert
    )
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    DispatchQueue.main.async {
      self.present(alert, animated: true, completion: nil)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    hideKeyboardWhenTappedAround()
    NotificationCenter.default.addObserver(
      self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification,
      object: nil)
    NotificationCenter.default.addObserver(
      self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification,
      object: nil)

    view.addSubview(environment)
    view.addSubview(dropDown)
    view.addSubview(envList)
    view.addSubview(langLabel)
    view.addSubview(langDropDown)
    view.addSubview(langList)
    view.addSubview(settingButton)
    view.addSubview(userIDLabel)
    view.addSubview(userIDTextField)
    view.addSubview(phoneLabel)
    view.addSubview(phoneTextField)
    view.addSubview(loginButton)
    view.addSubview(logoutButton)
    view.addSubview(scrollView)

    scrollView.addSubview(sdkContainer)

    sdkContainer.addSubview(balance)
    sdkContainer.addSubview(priceLabel)
    sdkContainer.addSubview(refreshButton)
    sdkContainer.addSubview(openWalletButton)
    sdkContainer.addSubview(openHistoryButton)
    sdkContainer.addSubview(userNameField)
    sdkContainer.addSubview(getQuotaButton)
    sdkContainer.addSubview(payCodeLabel)
    sdkContainer.addSubview(payCodeDropDown)
    sdkContainer.addSubview(payCodeList)
    sdkContainer.addSubview(qrPayButton)
    sdkContainer.addSubview(qrPayString)
    sdkContainer.addSubview(depositButton)
    sdkContainer.addSubview(moneyDeposit)
    sdkContainer.addSubview(serviceButton)
    sdkContainer.addSubview(serviceText)
    sdkContainer.addSubview(withDrawButton)
    sdkContainer.addSubview(moneyWithDraw)
    sdkContainer.addSubview(payButton)
    sdkContainer.addSubview(moneyPay)
    sdkContainer.addSubview(transferButton)
    sdkContainer.addSubview(moneyTransfer)
    sdkContainer.addSubview(getServiceButton)
    sdkContainer.addSubview(scanQRButton)
    sdkContainer.addSubview(kycButton)

    view.bringSubviewToFront(envList)
    view.bringSubviewToFront(langList)
    sdkContainer.bringSubviewToFront(payCodeList)

    phoneTextField.delegate = self
    moneyDeposit.delegate = self
    serviceText.delegate = self
    moneyWithDraw.delegate = self
    moneyPay.delegate = self
    envList.delegate = self
    langList.delegate = self
    payCodeList.delegate = self
    moneyTransfer.delegate = self
    qrPayString.delegate = self

    environment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
      .isActive =
      true
    environment.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true

    dropDown.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
      .isActive =
      true
    dropDown.leadingAnchor.constraint(equalTo: environment.trailingAnchor, constant: 30).isActive =
      true
    dropDown.heightAnchor.constraint(equalToConstant: 30).isActive = true
    dropDown.widthAnchor.constraint(equalToConstant: 150).isActive = true
    dropDown.addTarget(self, action: #selector(onPressDropDown(_:)), for: .touchUpInside)

    envList.isHidden = true
    envList.topAnchor.constraint(equalTo: dropDown.bottomAnchor).isActive = true
    envList.centerXAnchor.constraint(equalTo: dropDown.centerXAnchor).isActive = true
    envList.heightAnchor.constraint(equalToConstant: 100).isActive = true

    langLabel.topAnchor.constraint(equalTo: dropDown.bottomAnchor, constant: 10).isActive = true
    langLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true

    langDropDown.topAnchor.constraint(equalTo: dropDown.bottomAnchor, constant: 10).isActive = true
    langDropDown.leadingAnchor.constraint(equalTo: langLabel.trailingAnchor, constant: 30)
      .isActive = true
    langDropDown.heightAnchor.constraint(equalToConstant: 30).isActive = true
    langDropDown.widthAnchor.constraint(equalToConstant: 150).isActive = true
    langDropDown.addTarget(self, action: #selector(onPressLangDropDown), for: .touchUpInside)

    langList.isHidden = true
    langList.topAnchor.constraint(equalTo: langDropDown.bottomAnchor).isActive = true
    langList.centerXAnchor.constraint(equalTo: langDropDown.centerXAnchor).isActive = true
    langList.heightAnchor.constraint(equalToConstant: 100).isActive = true

    settingButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
      .isActive = true
    settingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive =
      true
    settingButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    settingButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
    settingButton.addTarget(self, action: #selector(onPressSetting(_:)), for: .touchUpInside)

    userIDLabel.topAnchor.constraint(equalTo: langLabel.bottomAnchor, constant: 20).isActive = true
    userIDLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive =
      true

    userIDTextField.topAnchor.constraint(equalTo: userIDLabel.bottomAnchor, constant: 5).isActive =
      true
    userIDTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30)
      .isActive = true
    userIDTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30)
      .isActive = true
    userIDTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    userIDTextField.text = UserDefaults.standard.string(forKey: "userID") ?? ""

    phoneLabel.topAnchor.constraint(equalTo: userIDTextField.bottomAnchor, constant: 20).isActive =
      true
    phoneLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive =
      true

    phoneTextField.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 5).isActive =
      true
    phoneTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30)
      .isActive = true
    phoneTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30)
      .isActive = true
    phoneTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    phoneTextField.text = UserDefaults.standard.string(forKey: "phone") ?? ""

    loginButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 20).isActive =
      true
    loginButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive =
      true
    loginButton.trailingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -5).isActive =
      true
    loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    loginButton.addTarget(self, action: #selector(submit), for: .touchUpInside)

    logoutButton.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 20).isActive =
      true
    logoutButton.leadingAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 5).isActive =
      true
    logoutButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30)
      .isActive = true
    logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)

    scrollView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20).isActive = true
    scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
    scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive =
      true
    scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true

    sdkContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
    sdkContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
    sdkContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
    sdkContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

    balance.topAnchor.constraint(equalTo: sdkContainer.topAnchor, constant: 20).isActive = true
    balance.leadingAnchor.constraint(equalTo: sdkContainer.leadingAnchor, constant: 10).isActive =
      true

    refreshButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    refreshButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
    refreshButton.topAnchor.constraint(equalTo: sdkContainer.topAnchor, constant: 20).isActive =
      true
    refreshButton.trailingAnchor.constraint(equalTo: sdkContainer.trailingAnchor, constant: -10)
      .isActive = true
    refreshButton.addTarget(self, action: #selector(getBalance(_:)), for: .touchUpInside)

    priceLabel.topAnchor.constraint(equalTo: sdkContainer.topAnchor, constant: 20).isActive = true
    priceLabel.trailingAnchor.constraint(equalTo: refreshButton.leadingAnchor, constant: -30)
      .isActive = true

    openWalletButton.topAnchor.constraint(equalTo: refreshButton.bottomAnchor, constant: 10)
      .isActive = true
    openWalletButton.leadingAnchor.constraint(equalTo: sdkContainer.leadingAnchor, constant: 10)
      .isActive = true
    openWalletButton.trailingAnchor.constraint(equalTo: sdkContainer.trailingAnchor, constant: -10)
      .isActive = true
    openWalletButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    openWalletButton.addTarget(self, action: #selector(openWalletAction), for: .touchUpInside)

    openHistoryButton.topAnchor.constraint(equalTo: openWalletButton.bottomAnchor, constant: 10)
      .isActive = true
    openHistoryButton.leadingAnchor.constraint(equalTo: sdkContainer.leadingAnchor, constant: 10)
      .isActive = true
    openHistoryButton.trailingAnchor.constraint(equalTo: sdkContainer.trailingAnchor, constant: -10)
      .isActive = true
    openHistoryButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    openHistoryButton.addTarget(self, action: #selector(openHistoryAction), for: .touchUpInside)

    userNameField.topAnchor.constraint(equalTo: openHistoryButton.bottomAnchor, constant: 10)
      .isActive = true
    userNameField.leadingAnchor.constraint(equalTo: sdkContainer.leadingAnchor, constant: 10)
      .isActive = true
    userNameField.trailingAnchor.constraint(equalTo: sdkContainer.trailingAnchor, constant: -10)
      .isActive = true
    userNameField.heightAnchor.constraint(equalToConstant: 30).isActive = true

    NSLayoutConstraint.activate([
      getQuotaButton.topAnchor.constraint(equalTo: userNameField.bottomAnchor, constant: 10),
      getQuotaButton.leadingAnchor.constraint(equalTo: sdkContainer.leadingAnchor, constant: 10),
      getQuotaButton.trailingAnchor.constraint(equalTo: sdkContainer.trailingAnchor, constant: -10),
    ])
    getQuotaButton.addTarget(self, action: #selector(onGetQuota), for: .touchUpInside)

    payCodeLabel.topAnchor.constraint(equalTo: getQuotaButton.bottomAnchor, constant: 10).isActive =
      true
    payCodeLabel.leadingAnchor.constraint(equalTo: sdkContainer.leadingAnchor, constant: 10)
      .isActive = true
    payCodeDropDown.topAnchor.constraint(equalTo: getQuotaButton.bottomAnchor, constant: 10)
      .isActive = true
    payCodeDropDown.leadingAnchor.constraint(equalTo: payCodeLabel.trailingAnchor, constant: 10)
      .isActive = true
    payCodeDropDown.heightAnchor.constraint(equalToConstant: 30).isActive = true
    payCodeDropDown.widthAnchor.constraint(equalToConstant: 200).isActive = true
    payCodeDropDown.addTarget(self, action: #selector(onPressPayCodeDropDown), for: .touchUpInside)
    payCodeList.isHidden = true
    payCodeList.topAnchor.constraint(equalTo: payCodeDropDown.bottomAnchor).isActive = true
    payCodeList.centerXAnchor.constraint(equalTo: payCodeDropDown.centerXAnchor).isActive = true
    payCodeList.heightAnchor.constraint(equalToConstant: 100).isActive = true

    payButton.topAnchor.constraint(equalTo: payCodeDropDown.bottomAnchor, constant: 10).isActive =
      true
    payButton.leadingAnchor.constraint(equalTo: sdkContainer.leadingAnchor, constant: 10).isActive =
      true
    payButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    payButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    payButton.addTarget(self, action: #selector(payAction), for: .touchUpInside)

    moneyPay.topAnchor.constraint(equalTo: payCodeDropDown.bottomAnchor, constant: 10).isActive =
      true
    moneyPay.leadingAnchor.constraint(equalTo: payButton.trailingAnchor, constant: 10).isActive =
      true
    moneyPay.trailingAnchor.constraint(equalTo: sdkContainer.trailingAnchor, constant: -10)
      .isActive = true
    moneyPay.heightAnchor.constraint(equalToConstant: 30).isActive = true

    qrPayButton.topAnchor.constraint(equalTo: payButton.bottomAnchor, constant: 10).isActive = true
    qrPayButton.leadingAnchor.constraint(equalTo: sdkContainer.leadingAnchor, constant: 10)
      .isActive = true
    qrPayButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    qrPayButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    qrPayButton.addTarget(self, action: #selector(onPayQR), for: .touchUpInside)

    qrPayString.topAnchor.constraint(equalTo: payButton.bottomAnchor, constant: 10).isActive = true
    qrPayString.leadingAnchor.constraint(equalTo: qrPayButton.trailingAnchor, constant: 10)
      .isActive = true
    qrPayString.trailingAnchor.constraint(equalTo: sdkContainer.trailingAnchor, constant: -10)
      .isActive = true
    qrPayString.heightAnchor.constraint(equalToConstant: 30).isActive = true

    depositButton.topAnchor.constraint(equalTo: qrPayButton.bottomAnchor, constant: 20).isActive =
      true
    depositButton.leadingAnchor.constraint(equalTo: sdkContainer.leadingAnchor, constant: 10)
      .isActive = true
    depositButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    depositButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    depositButton.addTarget(self, action: #selector(depositAction), for: .touchUpInside)

    moneyDeposit.topAnchor.constraint(equalTo: qrPayButton.bottomAnchor, constant: 20).isActive =
      true
    moneyDeposit.leadingAnchor.constraint(equalTo: depositButton.trailingAnchor, constant: 10)
      .isActive = true
    moneyDeposit.trailingAnchor.constraint(equalTo: sdkContainer.trailingAnchor, constant: -10)
      .isActive = true
    moneyDeposit.heightAnchor.constraint(equalToConstant: 30).isActive = true

    withDrawButton.topAnchor.constraint(equalTo: depositButton.bottomAnchor, constant: 10)
      .isActive = true
    withDrawButton.leadingAnchor.constraint(equalTo: sdkContainer.leadingAnchor, constant: 10)
      .isActive = true
    withDrawButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    withDrawButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    withDrawButton.addTarget(self, action: #selector(withDrawAction), for: .touchUpInside)

    moneyWithDraw.topAnchor.constraint(equalTo: depositButton.bottomAnchor, constant: 10).isActive =
      true
    moneyWithDraw.leadingAnchor.constraint(equalTo: withDrawButton.trailingAnchor, constant: 10)
      .isActive = true
    moneyWithDraw.trailingAnchor.constraint(equalTo: sdkContainer.trailingAnchor, constant: -10)
      .isActive = true
    moneyWithDraw.heightAnchor.constraint(equalToConstant: 30).isActive = true

    transferButton.topAnchor.constraint(equalTo: withDrawButton.bottomAnchor, constant: 10)
      .isActive = true
    transferButton.leadingAnchor.constraint(equalTo: sdkContainer.leadingAnchor, constant: 10)
      .isActive = true
    transferButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    transferButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    transferButton.addTarget(self, action: #selector(transferAction), for: .touchUpInside)

    moneyTransfer.topAnchor.constraint(equalTo: withDrawButton.bottomAnchor, constant: 10)
      .isActive = true
    moneyTransfer.leadingAnchor.constraint(equalTo: transferButton.trailingAnchor, constant: 10)
      .isActive = true
    moneyTransfer.trailingAnchor.constraint(equalTo: sdkContainer.trailingAnchor, constant: -10)
      .isActive = true
    moneyTransfer.heightAnchor.constraint(equalToConstant: 30).isActive = true

    serviceButton.topAnchor.constraint(equalTo: transferButton.bottomAnchor, constant: 20)
      .isActive = true
    serviceButton.leadingAnchor.constraint(equalTo: sdkContainer.leadingAnchor, constant: 10)
      .isActive = true
    serviceButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    serviceButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    serviceButton.addTarget(self, action: #selector(serviceAction), for: .touchUpInside)

    serviceText.topAnchor.constraint(equalTo: transferButton.bottomAnchor, constant: 20).isActive =
      true
    serviceText.leadingAnchor.constraint(equalTo: serviceButton.trailingAnchor, constant: 10)
      .isActive = true
    serviceText.trailingAnchor.constraint(equalTo: sdkContainer.trailingAnchor, constant: -10)
      .isActive = true
    serviceText.heightAnchor.constraint(equalToConstant: 30).isActive = true

    getServiceButton.topAnchor.constraint(equalTo: serviceButton.bottomAnchor, constant: 10)
      .isActive = true
    getServiceButton.leadingAnchor.constraint(equalTo: sdkContainer.leadingAnchor, constant: 10)
      .isActive = true
    getServiceButton.trailingAnchor.constraint(equalTo: sdkContainer.trailingAnchor, constant: -10)
      .isActive = true
    getServiceButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    getServiceButton.addTarget(self, action: #selector(getListService), for: .touchUpInside)

    scanQRButton.topAnchor.constraint(equalTo: getServiceButton.bottomAnchor, constant: 10)
      .isActive = true
    scanQRButton.leadingAnchor.constraint(equalTo: sdkContainer.leadingAnchor, constant: 10)
      .isActive = true
    scanQRButton.trailingAnchor.constraint(equalTo: sdkContainer.trailingAnchor, constant: -10)
      .isActive = true
    scanQRButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    scanQRButton.addTarget(self, action: #selector(scanQR), for: .touchUpInside)

    kycButton.topAnchor.constraint(equalTo: scanQRButton.bottomAnchor, constant: 10).isActive = true
    kycButton.leadingAnchor.constraint(equalTo: sdkContainer.leadingAnchor, constant: 10).isActive =
      true
    kycButton.trailingAnchor.constraint(equalTo: sdkContainer.trailingAnchor, constant: -10)
      .isActive = true
    kycButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    kycButton.addTarget(self, action: #selector(onKYC), for: .touchUpInside)

    updateViewConstraints()
    view.layoutIfNeeded()

    sdkContainer.bottomAnchor.constraint(equalTo: kycButton.bottomAnchor, constant: 8).isActive =
      true

    updateViewConstraints()
    view.layoutIfNeeded()
    scrollView.contentSize = sdkContainer.frame.size

    let env = UserDefaults.standard.string(forKey: "env") ?? ""
    if env == "" {
      setEnv(env: PayME.Env.SANDBOX, text: "sandbox")
    } else {
      envList.selectRow(Array(envData.keys).firstIndex(of: env)!, inComponent: 0, animated: true)
      setEnv(env: envData[env], text: env)
    }
    langList.selectRow(0, inComponent: 0, animated: true)
    setLang(lang: langData[0])
    payCodeList.selectRow(0, inComponent: 0, animated: true)
    setPayCode(payCodeData[0])
  }
}

extension ViewController: UITextFieldDelegate {
  // when user select a textfield, this method will be called
  func textFieldDidBeginEditing(_ textField: UITextField) {
    // set the activeTextField to the selected textfield
    self.activeTextField = textField
  }

  // when user click 'done' or dismiss the keyboard
  func textFieldDidEndEditing(_ textField: UITextField) {
    self.activeTextField = nil
  }
}

extension UITextField {
  func setLeftPaddingPoints(_ amount: CGFloat) {
    let paddingView = UIView(
      frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
    self.leftView = paddingView
    self.leftViewMode = .always
  }

  func setRightPaddingPoints(_ amount: CGFloat) {
    let paddingView = UIView(
      frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
    self.rightView = paddingView
    self.rightViewMode = .always
  }
}

extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap = UITapGestureRecognizer(
      target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }

  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}

var vSpinner: UIView?

extension UIViewController {
  func showSpinner(onView: UIView) {
    let spinnerView = UIView(frame: onView.bounds)
    spinnerView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
    let ai = UIActivityIndicatorView(style: .large)
    ai.startAnimating()
    ai.center = spinnerView.center

    DispatchQueue.main.async {
      spinnerView.addSubview(ai)
      onView.addSubview(spinnerView)
    }

    vSpinner = spinnerView
  }

  func removeSpinner() {
    DispatchQueue.main.async {
      vSpinner?.removeFromSuperview()
      vSpinner = nil
    }
  }
}
