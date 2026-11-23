import UIKit

extension UIImage {
    /// Уменьшает изображение так, чтобы длинная сторона не превышала maxSide.
    /// Заодно «запекает» ориентацию, поэтому результат всегда имеет ориентацию .up.
    func resized(maxSide: CGFloat) -> UIImage {
        let ratio = min(1, maxSide / max(size.width, size.height))
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        return UIGraphicsImageRenderer(size: newSize, format: format).image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }

    func normalized() -> UIImage {
        resized(maxSide: .greatestFiniteMagnitude)
    }
}
