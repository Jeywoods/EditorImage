import CoreImage

/// Фильтр изображения со своими параметрами.
/// Чтобы добавить новый фильтр, достаточно создать новый класс с этим протоколом.
protocol ImageFilter: AnyObject {
    var name: String { get }
    var parameters: [FilterParameter] { get set }
    func apply(to image: CIImage) -> CIImage
}

extension ImageFilter {
    func reset() {
        for index in parameters.indices {
            parameters[index].value = parameters[index].defaultValue
        }
    }
}
