//
//  WebViewController.swift
//  PayMESDK
//
//  Created by HuyOpen on 9/29/20.
//  Copyright © 2020 PayME. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate, WKScriptMessageHandler, WKNavigationDelegate, PanModalPresentable {
    var KYCAgain: Bool? = nil

    var panScrollable: UIScrollView? {
        nil
    }

    var topOffset: CGFloat {
        0.0
    }

    var springDamping: CGFloat {
        1.0
    }

    var transitionDuration: Double {
        0.4
    }

    var transitionAnimationOptions: UIView.AnimationOptions {
        [.allowUserInteraction, .beginFromCurrentState]
    }

    var shouldRoundTopCorners: Bool {
        false
    }

    var showDragIndicator: Bool {
        false
    }

    var vc: UIImagePickerController!
    var urlRequest: String = ""
    var webView: WKWebView!
    var onCommunicate: String = "onCommunicate"
    var onClose: String = "onClose"
    var openCamera: String = "openCamera"
    var onErrorBack: String = "onError"
    var onRegisterSuccess: String = "onRegisterSuccess"
    var onPay: String = "onPay"
    var onDeposit: String = "onDeposit"
    var onWithdraw: String = "onWithdraw"
    var onTransfer: String = "onTransfer"
    var onUpdateIdentify: String = "onUpdateIdentify"
    var showButtonCloseNapas: String = "showButtonCloseNapas"
    var form = ""
    var imageFront: UIImage?
    var imageBack: UIImage?
    var active: Int?
    var individualTaskTimer: Timer!
    var payMEFunction: PayMEFunction?

    private var onSuccessWebView: ((String) -> ())? = nil
    private var onFailWebView: ((String) -> ())? = nil
    private var onSuccess: ((Dictionary<String, AnyObject>) -> ())? = nil
    private var onError: (([String: AnyObject]) -> ())? = nil
    private var onNavigateToHost: ((String) -> ())? = nil

    let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(for: QRNotFound.self, named: "16Px"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(payMEFunction: PayMEFunction?, nibName: String?, bundle: Bundle?) {
        self.payMEFunction = payMEFunction
        super.init(nibName: nibName, bundle: bundle)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func loadView() {
        PayME.currentVC?.navigationItem.hidesBackButton = true
        PayME.currentVC?.navigationController?.isNavigationBarHidden = true

        let userController: WKUserContentController = WKUserContentController()
        userController.add(self, name: onCommunicate)
        userController.add(self, name: onClose)
        userController.add(self, name: openCamera)
        userController.add(self, name: onErrorBack)
        userController.add(self, name: onPay)
        userController.add(self, name: onRegisterSuccess)
        userController.add(self, name: onDeposit)
        userController.add(self, name: onWithdraw)
        userController.add(self, name: onTransfer)
        userController.add(self, name: onUpdateIdentify)
        userController.add(self, name: showButtonCloseNapas)
        userController.addUserScript(getZoomDisableScript())

        let config = WKWebViewConfiguration()
        config.userContentController = userController
        webView = WKWebView(frame: .zero, configuration: config)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView

        reloadHomePage()
    }

    func reloadHomePage() {
        if (form == "") {
            let urlString = urlRequest.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let myURL = URL(string: urlString!)
            let myRequest: URLRequest
            if myURL != nil {
                myRequest = URLRequest(url: myURL!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
            } else {
                myRequest = URLRequest(url: URL(string: "http://google.com/")!)
            }

            if #available(iOS 11.0, *) {
                webView.scrollView.contentInsetAdjustmentBehavior = .never;
            } else {
                automaticallyAdjustsScrollViewInsets = false;
            }
            webView.scrollView.alwaysBounceVertical = false
            webView.scrollView.bounces = false
            webView.load(myRequest)
            closeButton.isHidden = true
        } else {
            webView.loadHTMLString(form, baseURL: nil)
            closeButton.isHidden = false
        }
    }

//    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
//        showSpinner(onView: PayME.currentVC!.view)
//    }
//
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        removeSpinner()
//    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("error 01")
        let wkError = (error as NSError)
        removeSpinner()
        if (wkError.code == NSURLErrorNotConnectedToInternet) {
            onError!(["code": PayME.ResponseCode.NETWORK as AnyObject, "message": wkError.localizedDescription as AnyObject])
        } else {
            onError!(["code": PayME.ResponseCode.SYSTEM as AnyObject, "message": wkError.localizedDescription as AnyObject])
        }
        onCloseWebview()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let wkError = (error as NSError)
        if (form == "") {
            removeSpinner()
            if (wkError.code == NSURLErrorNotConnectedToInternet) {
                onError!(["code": PayME.ResponseCode.NETWORK as AnyObject, "message": wkError.localizedDescription as AnyObject])
            } else {
                onError!(["code": PayME.ResponseCode.SYSTEM as AnyObject, "message": wkError.localizedDescription as AnyObject])
            }
            onCloseWebview()
        } else {
            if (wkError.code != 102) {
                onFailWebView!(wkError.localizedDescription)
            }
        }
    }

    private func getZoomDisableScript() -> WKUserScript {
        let source: String = "var meta = document.createElement('meta');" +
                "meta.name = 'viewport';" +
                "meta.content = 'width=device-width, initial-scale=1.0, maximum- scale=1.0, user-scalable=no';" +
                "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);"
        return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }

    func updateIdentify() {
        let injectedJS = "       const script = document.createElement('script');\n" +
                "          script.type = 'text/javascript';\n" +
                "          script.async = true;\n" +
                "          script.text = 'onUpdateIdentify()';\n" +
                "          document.body.appendChild(script);\n" +
                "          true; // note: this is required, or you'll sometimes get silent failures\n"
        webView.evaluateJavaScript("(function() {\n" + injectedJS + ";\n})();")
    }

    func reload() {
        webView.reload()
    }

    override func viewDidLoad() {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
            for record in records {
                if record.displayName.contains("payme.com.vn") {
                    dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: [record], completionHandler: {

                    })
                }
            }
        }
        if #available(iOS 9.0, *) {
            let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
            let date = NSDate(timeIntervalSince1970: 0)
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date as Date, completionHandler: {})
        } else {
            var libraryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, false).first!
            libraryPath += "/Cookies"

            do {
                try FileManager.default.removeItem(atPath: libraryPath)
            } catch {
                print("Lỗi")
            }
            URLCache.shared.removeAllCachedResponses()
        }

        webView.addSubview(closeButton)
        closeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        closeButton.topAnchor.constraint(equalTo: webView.topAnchor, constant: 60).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: webView.trailingAnchor, constant: -20).isActive = true
        closeButton.addTarget(self, action: #selector(closeWebViewPaymentModal), for: .touchUpInside)
    }

    @objc func closeWebViewPaymentModal() {
        if form == "" { //form == "" -> payme open wallet, form != "" -> napas
            reloadHomePage()
        } else {
            dismiss(animated: true) {
                PayME.currentVC?.dismiss(animated: true)
            }
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if (form != "") {
            if (navigationAction.request.url != nil) {
                let host = navigationAction.request.url!.host ?? ""
//                if host.contains("payme.vn") == true || host.contains("centinelapistag.cardinalcommerce.com") {
                onNavigateToHost?(host)
                if (host == "payme.vn") {
                    let params = navigationAction.request.url!.queryParameters ?? ["": ""]
                    if (params["success"] == "true") {
                        DispatchQueue.main.async {
                            self.onSuccessWebView!("success")
                        }
                        decisionHandler(.cancel)
                        return
                    }
                    if (params["success"] == "false") {
                        onFailWebView!(params["message"]!)
                        decisionHandler(.cancel)
                        return
                    }
                    decisionHandler(.allow)

                } else {
                    decisionHandler(.allow)
                }

            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let response = navigationResponse.response as? HTTPURLResponse {
            if response.statusCode == 200 {
                onNavigateToHost?("authenticated")
            }
        }
        decisionHandler(.allow)
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == onDeposit || message.name == onWithdraw || message.name == onTransfer {
            onCloseWebview()
            if let dictionary = message.body as? [String: AnyObject] {
                let status = dictionary["data"]!["status"] as! String
                if status == "SUCCEEDED" {
                    onSuccess!(dictionary["data"] as! [String: AnyObject])
                } else {
                    let message = dictionary["data"]!["message"] as? String ?? "Có lỗi xảy ra"
                    onError!(["code": PayME.ResponseCode.OTHER as AnyObject, "message": message as AnyObject])
                }
            }
        }
        if message.name == onUpdateIdentify {
            setupCamera(dictionary: [
                "identifyImg": true,
                "faceImg": false,
                "kycVideo": false
            ] as [String: AnyObject], isUpdateIdentify: true)
        }
        if message.name == openCamera {
            if let dictionary = message.body as? [String: AnyObject] {
                setupCamera(dictionary: dictionary)
            }
        }
        if message.name == showButtonCloseNapas {
            if let dictionary = message.body as? [String: AnyObject] {
                if let isShowButtonClose = dictionary["isShowButtonClose"] as? Bool {
                    closeButton.isHidden = !isShowButtonClose
                }
            }
        }
        if message.name == onCommunicate {
            if let dictionary = message.body as? [String: AnyObject] {
                let actions = (dictionary["actions"] as? String) ?? ""
                if (actions == "onRegisterSuccess") {
                    if let data = dictionary["data"] as? [String: AnyObject] {
                        if let dataInit = data["Init"] as? [String: AnyObject] {
                            let accessToken = (dataInit["accessToken"] as? String) ?? ""
                            let kycState = (dataInit["kyc"]!["state"] as? String) ?? ""
                            let isAccountActivated = (dataInit["isAccountActived"] as? Bool) ?? true
                            payMEFunction?.isAccountActivated = isAccountActivated
                            payMEFunction?.dataInit = dataInit
                            payMEFunction?.accessToken = accessToken
                            payMEFunction?.kycState = kycState
                            payMEFunction?.handShake = (dataInit["handShake"] as? String) ?? ""
                            payMEFunction?.request.setAccessData(kycState == "APPROVED" ? accessToken : "", accessToken, nil)
                        }
                    }
                    onSuccess!(dictionary)
                }
                if (actions == "onNetWorkError") {
                    if let data = dictionary["data"] as? [String: AnyObject] {
                        onError!(["code": PayME.ResponseCode.NETWORK as AnyObject, "message": data["message"] as AnyObject])
                    }
                }
                if (actions == "onKYC") {
                    if let data = dictionary["data"] as? [String: AnyObject] {
                        setupCamera(dictionary: data)
                    }
                }
            }
        }
        if message.name == onErrorBack {
            if let dictionary = message.body as? [String: AnyObject] {
                removeSpinner()
                let code = dictionary["code"] as! Int
                if (code == 401) {
                    onCloseWebview()
                    payMEFunction?.resetInitState()
                }
                onError!(dictionary)
            }
        }
        if message.name == onClose {
            onCloseWebview()
        }
        if message.name == onPay {
            payMEFunction?.openQRCode(currentVC: self, onSuccess: onSuccess!, onError: onError!)
        }
    }


    func setupCamera(dictionary: [String: AnyObject], isUpdateIdentify: Bool? = nil) {
        KYCController.reset()
        KYCController.isUpdateIdentify = isUpdateIdentify ?? KYCController.isUpdateIdentify
        if let dictionary = dictionary as? [String: Bool] {
            let kycController = KYCController(payMEFunction: payMEFunction!, flowKYC: dictionary)
            kycController.kyc()
        }
    }

    func onCloseWebview() {
        onRemoveMessageHandler()
        if PayME.isRecreateNavigationController {
            dismiss(animated: true) {
                PayME.isWebviewOpening = false
            }
        } else {
            navigationController?.popViewController(animated: true) {
                PayME.isWebviewOpening = false
            }
        }
    }

    private func onRemoveMessageHandler() {
        let userController = webView.configuration.userContentController
        userController.removeScriptMessageHandler(forName: onCommunicate)
        userController.removeScriptMessageHandler(forName: onClose)
        userController.removeScriptMessageHandler(forName: openCamera)
        userController.removeScriptMessageHandler(forName: onErrorBack)
        userController.removeScriptMessageHandler(forName: onPay)
        userController.removeScriptMessageHandler(forName: onRegisterSuccess)
    }

    public func setOnSuccessCallback(onSuccess: @escaping (Dictionary<String, AnyObject>) -> ()) {
        self.onSuccess = onSuccess
    }

    public func setOnSuccessWebView(onSuccessWebView: @escaping (String) -> ()) {
        self.onSuccessWebView = onSuccessWebView
    }

    public func setOnFailWebView(onFailWebView: @escaping (String) -> ()) {
        self.onFailWebView = onFailWebView
    }

    public func setOnNavigateToHost(onNavigateToHost: @escaping (String) -> ()){
        self.onNavigateToHost = onNavigateToHost
    }

    public func setOnErrorCallback(onError: @escaping ([String: AnyObject]) -> ()) {
        self.onError = onError
    }

    public func setURLRequest(_ url: String) {
        urlRequest = url
    }
}



