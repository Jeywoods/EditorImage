import CoreImage
import UIKit

protocol ImageRendering {
    func render(_ image: CIImage) -> UIImage?
}

final class CIImageRenderer: ImageRendering {
    // CIContext дорого создавать, поэтому он один на весь сервис.
    private let context = CIContext()

    func render(_ image: CIImage) -> UIImage? {
        guard let cgImage = context.createCGImage(image, from: image.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
