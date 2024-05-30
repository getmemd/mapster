import UIKit

// Расширение для UIWindow, чтобы всегда держать ProgressHudContainerView поверх других вью
extension UIWindow {
    // Переопределение метода, вызываемого при добавлении подвидов в UIWindow
    open override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        // Если ProgressHudContainerView существует среди подвидов, принести его на передний план
        if let progressHudContainerView = subviews.first(where: { $0 is ProgressHudContainerView }) {
            bringSubviewToFront(progressHudContainerView)
        }
    }
}
