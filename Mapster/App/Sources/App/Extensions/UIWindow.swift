import UIKit

extension UIWindow {
    open override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        if let progressHudContainerView = subviews.first(where: { $0 is ProgressHudContainerView }) {
            bringSubviewToFront(progressHudContainerView)
        }
    }
}
