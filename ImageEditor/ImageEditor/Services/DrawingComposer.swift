import PencilKit
import UIKit

protocol DrawingComposing {
    func compose(image: UIImage, drawing: PKDrawing, canvasSize: CGSize) -> UIImage
}

/// Накладывает рисунок PencilKit на изображение в его полном разрешении.
final class DrawingComposer: DrawingComposing {
    func compose(image: UIImage, drawing: PKDrawing, canvasSize: CGSize) -> UIImage {
        guard !drawing.bounds.isEmpty, canvasSize.width > 0 else { return image }

        // Холст на экране меньше изображения, поэтому рисунок увеличиваем.
        let scale = image.size.width / canvasSize.width
        var strokes = UIImage()
        UITraitCollection(userInterfaceStyle: .light).performAsCurrent {
            strokes = drawing.image(from: CGRect(origin: .zero, size: canvasSize), scale: scale)
        }

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        return UIGraphicsImageRenderer(size: image.size, format: format).image { _ in
            let bounds = CGRect(origin: .zero, size: image.size)
            image.draw(in: bounds)
            strokes.draw(in: bounds)
        }
    }
}
