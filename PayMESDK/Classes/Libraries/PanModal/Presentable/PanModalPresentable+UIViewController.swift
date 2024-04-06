//
//  PanModalPresentable+UIViewController.swift
//  PayMESDK
//
//  Created by HuyOpen on 10/26/20.
//

#if os(iOS)
  import UIKit

  /// Extends PanModalPresentable with helper methods
  /// when the conforming object is a UIViewController
  extension PanModalPresentable where Self: UIViewController {

    public typealias AnimationBlockType = () -> Void
    public typealias AnimationCompletionType = (Bool) -> Void

    /**
     For Presentation, the object must be a UIViewController & confrom to the PanModalPresentable protocol.
     */
    public typealias LayoutType = UIViewController & PanModalPresentable

    /**
     A function wrapper over the `transition(to state: PanModalPresentationController.PresentationState)`
     function in the PanModalPresentationController.
     */
    public func panModalTransition(to state: PanModalPresentationController.PresentationState) {
      presentedVC?.transition(to: state)
    }

    /**
     A function wrapper over the `setNeedsLayoutUpdate()`
     function in the PanModalPresentationController.
     - Note: This should be called whenever any of the values for the PanModalPresentable protocol are changed.
     */
    public func panModalSetNeedsLayoutUpdate() {
      presentedVC?.setNeedsLayoutUpdate()
    }

    /**
     Operations on the scroll view, such as content height changes, or when inserting/deleting rows can cause the pan modal to jump,
     caused by the pan modal responding to content offset changes.
     To avoid this, you can call this method to perform scroll view updates, with scroll observation temporarily disabled.
     */
    public func panModalPerformUpdates(_ updates: () -> Void) {
      presentedVC?.performUpdates(updates)
    }

    /**
     A function wrapper over the animate function in PanModalAnimator.
     This can be used for animation consistency on views within the presented view controller.
     */
    public func panModalAnimate(
      _ animationBlock: @escaping AnimationBlockType, _ completion: AnimationCompletionType? = nil
    ) {
      PanModalAnimator.animate(animationBlock, config: self, completion)
    }

  }
#endif
