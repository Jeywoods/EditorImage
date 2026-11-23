import Foundation

/// Настраиваемый параметр фильтра: название, диапазон и текущее значение.
struct FilterParameter {
    let title: String
    let range: ClosedRange<Double>
    let defaultValue: Double
    var value: Double

    init(title: String, range: ClosedRange<Double>, defaultValue: Double) {
        self.title = title
        self.range = range
        self.defaultValue = defaultValue
        self.value = defaultValue
    }
}
