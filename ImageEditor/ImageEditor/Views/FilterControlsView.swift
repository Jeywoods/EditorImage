import SwiftUI

struct FilterControlsView: View {
    let pipeline: FilterPipeline
    let onChange: () -> Void
    let onReset: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(pipeline.filters, id: \.name) { filter in
                        FilterSectionView(filter: filter, onChange: onChange)
                    }
                }
            }
            Button("Сбросить", action: onReset)
                .buttonStyle(.bordered)
        }
        .frame(maxHeight: 280)
    }
}

private struct FilterSectionView: View {
    let filter: any ImageFilter
    let onChange: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(filter.name)
                .font(.headline)
            ForEach(filter.parameters.indices, id: \.self) { index in
                VStack(alignment: .leading, spacing: 2) {
                    Text(filter.parameters[index].title)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Slider(value: binding(for: index), in: filter.parameters[index].range)
                }
            }
        }
    }

    private func binding(for index: Int) -> Binding<Double> {
        Binding(
            get: { filter.parameters[index].value },
            set: {
                filter.parameters[index].value = $0
                onChange()
            }
        )
    }
}
