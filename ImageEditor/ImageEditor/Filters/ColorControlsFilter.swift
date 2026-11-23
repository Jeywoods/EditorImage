import CoreImage.CIFilterBuiltins
import Observation

@Observable
final class ColorControlsFilter: ImageFilter {
    let name = "Цвет"
    var parameters = [
        FilterParameter(title: "Насыщенность", range: 0 ... 2, defaultValue: 1),
        FilterParameter(title: "Яркость", range: -1 ... 1, defaultValue: 0),
        FilterParameter(title: "Контраст", range: 0 ... 2, defaultValue: 1)
    ]

    func apply(to image: CIImage) -> CIImage {
        let filter = CIFilter.colorControls()
        filter.inputImage = image
        filter.saturation = Float(parameters[0].value)
        filter.brightness = Float(parameters[1].value)
        filter.contrast = Float(parameters[2].value)
        return filter.outputImage ?? image
    }
}
