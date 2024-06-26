//
//  KYCStore.swift
//  PayMESDK
//
//  Created by HuyOpen on 1/6/21.
//

import Foundation

public class UploadKYC {
  var imageDocument: [UIImage]?
  var imageAvatar: UIImage?
  var videoKYC: URL?
  var active: Int?
  var flowKYC: [String: Bool]?
  private var pathFront: String?
  private var pathBack: String?
  private var pathAvatar: String?
  private var pathVideo: String?
  private let payMEFunction: PayMEFunction
  private let isUpdateIdentify: Bool?

  init(
    payMEFunction: PayMEFunction, imageDocument: [UIImage]?, imageAvatar: UIImage?, videoKYC: URL?,
    active: Int?, isUpdateIdentify: Bool?
  ) {
    self.payMEFunction = payMEFunction
    self.imageDocument = imageDocument
    self.imageAvatar = imageAvatar
    self.videoKYC = videoKYC
    self.active = active
    self.isUpdateIdentify = isUpdateIdentify
  }

  func upload() {
    PayME.currentVC?.navigationItem.hidesBackButton = true
    PayME.currentVC?.navigationController?.isNavigationBarHidden = true
    let vc = LoadingKYC()
    vc.modalPresentationStyle = .fullScreen
    PayME.currentVC?.present(vc, animated: false)
    uploadDocument()
  }

  private func verifyKYC() {
    payMEFunction.request.verifyKYC(
      pathFront: pathFront, pathBack: pathBack, pathAvatar: pathAvatar, pathVideo: pathVideo,
      isUpdateIdentify: isUpdateIdentify ?? false,
      onSuccess: { response in
        print(response)
        if let result = response["Account"]!["KYC"] as? [String: AnyObject] {
          let succeeded = result["succeeded"] as? Bool
          if succeeded != nil {
            if succeeded! == true {
              DispatchQueue.main.async {
                PayME.currentVC?.dismiss(animated: false) {
                  guard let navigationController = PayME.currentVC?.navigationController else {
                    return
                  }
                  var navigationArray = navigationController.viewControllers
                  if PayME.isRecreateNavigationController {
                    PayME.currentVC?.navigationController?.viewControllers = [navigationArray[0]]
                    let rootViewController = navigationArray.first

                    if rootViewController is KYCCameraController
                      || rootViewController is AvatarController
                      || rootViewController is VideoController
                    {
                      PayME.rootVC?.dismiss(animated: true)
                    } else {
                      if self.isUpdateIdentify ?? false {
                        (rootViewController as? WebViewController)?.updateIdentify()
                      } else {
                        (rootViewController as? WebViewController)?.onReloadKYCStatus()
                      }
                    }
                  } else {
                    if self.imageDocument != nil {
                      if self.active == 2 {
                        navigationArray.removeLast()
                        navigationArray.removeLast()
                      } else {
                        navigationArray.removeLast()
                        navigationArray.removeLast()
                        navigationArray.removeLast()
                        navigationArray.removeLast()
                      }
                    }
                    if self.imageAvatar != nil {
                      navigationArray.removeLast()
                      navigationArray.removeLast()
                    }
                    if self.videoKYC != nil {
                      navigationArray.removeLast()
                      navigationArray.removeLast()
                    }
                    PayME.currentVC?.navigationController?.viewControllers = navigationArray
                    if self.isUpdateIdentify ?? false {
                      (PayME.currentVC?.navigationController?.visibleViewController
                        as? WebViewController)?.updateIdentify()
                    } else {
                      (PayME.currentVC?.navigationController?.visibleViewController
                        as? WebViewController)?.onReloadKYCStatus()
                    }
                  }
                }
              }
            } else {
              print("minh khoa 4")
              print(result)
              PayME.currentVC?.dismiss(animated: false)
              self.toastMess(
                title: "error".localize(),
                message: result["message"] as? String ?? "Something went wrong")
            }
          } else {
            print("minh khoa 3")
            print(result)
            PayME.currentVC?.dismiss(animated: false)
            self.toastMess(
              title: "error".localize(),
              message: result["message"] as? String ?? "Something went wrong")
          }
        }
      },
      onError: { error in
        if let extensions = error["extensions"] as? [String: AnyObject] {
          let code = extensions["code"] as? Int
          if code != nil {
            if code == 401 {
              self.payMEFunction.resetInitState()
              guard let navigationController = PayME.currentVC?.navigationController else {
                return
              }
              let navigationArray = navigationController.viewControllers
              PayME.currentVC?.navigationController?.viewControllers = [navigationArray[0]]
            }
          }
          print("minh khoa 1")
          print(error)
          self.toastMess(
            title: "error".localize(),
            message: error["message"] as? String ?? "Something went wrong")
          PayME.currentVC?.dismiss(animated: false)
        } else {
          print("minh khoa 2")
          print(error)
          self.toastMess(title: "error".localize(), message: "Something went wrong")
          PayME.currentVC?.dismiss(animated: false)
        }
      })
  }

  private func uploadVideo() {
    if videoKYC != nil {
      payMEFunction.request.uploadVideoKYC(
        videoURL: videoKYC!,
        onSuccess: { response in
          print(response)
          let code = response["code"]! as! Int
          if code == 1000 {
            let data = response["data"] as! [[String: Any]]
            self.pathVideo = data[0]["path"] as? String ?? ""
            self.verifyKYC()
          } else {
            PayME.currentVC?.dismiss(animated: false)
            self.toastMess(
              title: "error".localize(),
              message: response["data"]!["message"] as? String ?? "Something went wrong")
          }
        },
        onError: { error in
          PayME.currentVC?.dismiss(animated: false)
          self.toastMess(
            title: "error".localize(),
            message: (error["message"] as? String) ?? "Something went wrong")
        })
    } else {
      verifyKYC()
    }
  }

  private func uploadAvatar() {
    if imageAvatar != nil {
      payMEFunction.request.uploadImageKYC(
        imageFront: imageAvatar!, imageBack: nil,
        onSuccess: { response in
          print(response)
          let code = response["code"]! as! Int
          if code == 1000 {
            let data = response["data"] as! [[String: Any]]
            self.pathAvatar = data[0]["path"] as? String ?? ""
            self.uploadVideo()
          } else {
            PayME.currentVC?.dismiss(animated: false)
            self.toastMess(
              title: "error".localize(),
              message: response["data"]!["message"] as? String ?? "Something went wrong")
          }
        },
        onError: { error in
          PayME.currentVC?.dismiss(animated: false)
          self.toastMess(
            title: "error".localize(),
            message: (error["message"] as? String) ?? "Something went wrong")
        })
    } else {
      uploadVideo()
    }
  }

  private func uploadDocument() {
    if imageDocument != nil {
      if active == 2 {
        payMEFunction.request.uploadImageKYC(
          imageFront: imageDocument![0], imageBack: nil,
          onSuccess: { response in
            print(response)
            let code = response["code"]! as! Int
            if code == 1000 {
              let data = response["data"] as! [[String: Any]]
              self.pathFront = data[0]["path"] as? String ?? ""
              self.uploadAvatar()
            } else {
              PayME.currentVC?.dismiss(animated: false)
              self.toastMess(
                title: "error".localize(),
                message: response["data"]!["message"] as? String ?? "Something went wrong")
            }

          },
          onError: { error in
            PayME.currentVC?.dismiss(animated: false)
            self.toastMess(
              title: "error".localize(),
              message: (error["message"] as? String) ?? "Something went wrong")
          })
      } else {
        payMEFunction.request.uploadImageKYC(
          imageFront: imageDocument![0], imageBack: imageDocument![1],
          onSuccess: { response in
            let code = response["code"]! as! Int
            if code == 1000 {
              let data = response["data"] as! [[String: Any]]
              self.pathFront = data[0]["path"] as? String ?? ""
              self.pathBack = data[1]["path"] as? String ?? ""
              self.uploadAvatar()
            } else {
              PayME.currentVC?.dismiss(animated: false)
              self.toastMess(
                title: "error".localize(),
                message: response["data"]!["message"] as? String ?? "Something went wrong")
            }

          },
          onError: { error in
            PayME.currentVC?.dismiss(animated: false)
            self.toastMess(
              title: "error".localize(),
              message: (error["message"] as? String) ?? "Something went wrong")
          })
      }
    } else {
      uploadAvatar()
    }
  }

  private func toastMess(title: String, message: String) {
    let alert = UIAlertController(
      title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    PayME.currentVC?.present(alert, animated: true, completion: nil)
  }
}
