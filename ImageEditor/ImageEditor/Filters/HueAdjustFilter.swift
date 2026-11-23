import CoreImage.CIFilterBuiltins
import Observation

@Observable
final class HueAdjustFilter: ImageFilter {
    let name = "Оттенок"
    var parameters = [
        FilterParameter(title: "Угол", range: -Double.pi ... Double.pi, defaultValue: 0)
    ]

    func apply(to image: CIImage) -> CIImage {
        let filter = CIFilter.hueAdjust()
        filter.inputImage = image
        filter.angle = Float(parameters[0].value)
        return filter.outputImage ?? image
    }
}
