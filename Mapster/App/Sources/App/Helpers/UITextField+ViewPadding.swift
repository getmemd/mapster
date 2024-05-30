import UIKit

// Расширение для UITextField для добавления отступа и иконки
extension UITextField {
    // Метод для добавления отступа и иконки
    func addPaddingAndIcon(_ image: UIImage?, padding: CGFloat, isLeftView: Bool) {
        guard let image else { return }
        let frame = CGRect(x: 0, y: 0, width: image.size.width + padding, height: image.size.height)
        let outerView = UIView(frame: frame)
        let iconView = UIImageView(frame: frame)
        iconView.image = image
        iconView.contentMode = .center
        outerView.addSubview(iconView)
        // Установка внешнего вида как левого или правого вида текстового поля
        if isLeftView {
            leftViewMode = .always
            leftView = outerView
        } else {
            rightViewMode = .always
            rightView = outerView
        }
    }
}
