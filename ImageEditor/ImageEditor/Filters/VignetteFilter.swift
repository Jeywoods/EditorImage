import CoreImage.CIFilterBuiltins
import Observation

@Observable
final class VignetteFilter: ImageFilter {
    let name = "Виньетка"
    var parameters = [
        FilterParameter(title: "Интенсивность", range: 0 ... 2, defaultValue: 0),
        FilterParameter(title: "Радиус", range: 0 ... 3, defaultValue: 1)
    ]

    func apply(to image: CIImage) -> CIImage {
        let filter = CIFilter.vignette()
        filter.inputImage = image
        filter.intensity = Float(parameters[0].value)
        filter.radius = Float(parameters[1].value)
        return filter.outputImage ?? image
    }
}
