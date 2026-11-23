import CoreImage

/// Применяет фильтры к изображению по очереди.
final class FilterPipeline {
    let filters: [any ImageFilter]

    init(filters: [any ImageFilter]) {
        self.filters = filters
    }

    func apply(to image: CIImage) -> CIImage {
        filters.reduce(image) { $1.apply(to: $0) }
    }

    func reset() {
        filters.forEach { $0.reset() }
    }
}
