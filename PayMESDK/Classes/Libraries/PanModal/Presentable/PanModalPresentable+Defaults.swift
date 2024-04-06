//
//  PanModalPresentable+Defaults.swift
//  PayMESDK
//
//  Created by HuyOpen on 10/26/20.
//

#if os(iOS)
  import UIKit

  /// Default values for the PanModalPresentable.

  extension PanModalPresentable where Self: UIViewController {

    public var topOffset: CGFloat {
      return topLayoutOffset + 21.0
    }

    public var shortFormHeight: PanModalHeight {
      return longFormHeight
    }

    public var longFormHeight: PanModalHeight {

      guard let scrollView = panScrollable
      else { return .maxHeight }

      // called once during presentation and stored
      scrollView.layoutIfNeeded()
      return .contentHeight(scrollView.contentSize.height)
    }

    public var cornerRadius: CGFloat {
      return 8.0
    }

    public var springDamping: CGFloat {
      return 0.8
    }

    public var transitionDuration: Double {
      return PanModalAnimator.Constants.defaultTransitionDuration
    }

    public var transitionAnimationOptions: UIView.AnimationOptions {
      return [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState]
    }

    public var panModalBackgroundColor: UIColor {
      return UIColor.black.withAlphaComponent(0.7)
    }

    public var dragIndicatorBackgroundColor: UIColor {
      return UIColor.lightGray
    }

    public var scrollIndicatorInsets: UIEdgeInsets {
      let top = shouldRoundTopCorners ? cornerRadius : 0
      return UIEdgeInsets(top: CGFloat(top), left: 0, bottom: bottomLayoutOffset, right: 0)
    }

    public var anchorModalToLongForm: Bool {
      return true
    }

    public var allowsExtendedPanScrolling: Bool {

      guard let scrollView = panScrollable
      else { return false }

      scrollView.layoutIfNeeded()
      return scrollView.contentSize.height > (scrollView.frame.height - bottomLayoutOffset)
    }

    public var allowsDragToDismiss: Bool {
      return true
    }

    public var allowsTapToDismiss: Bool {
      return true
    }

    public var isUserInteractionEnabled: Bool {
      return true
    }

    public var isHapticFeedbackEnabled: Bool {
      return true
    }

    public var shouldRoundTopCorners: Bool {
      return isPanModalPresented
    }

    public var showDragIndicator: Bool {
      return shouldRoundTopCorners
    }

    public func shouldRespond(to panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
      return true
    }

    public func willRespond(to panModalGestureRecognizer: UIPanGestureRecognizer) {

    }

    public func shouldTransition(to state: PanModalPresentationController.PresentationState) -> Bool
    {
      return true
    }

    public func shouldPrioritize(panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
      return false
    }

    public func willTransition(to state: PanModalPresentationController.PresentationState) {

    }

    public func panModalWillDismiss() {

    }

    public func panModalDidDismiss() {

    }
  }
#endif
