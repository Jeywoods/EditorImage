import PencilKit
import PhotosUI
import SwiftUI

struct ContentView: View {
    @Bindable var viewModel: ImageEditorViewModel
    @State private var pickerItem: PhotosPickerItem?

    var body: some View {
        NavigationStack {
            Group {
                if let image = viewModel.previewImage {
                    editor(image: image)
                } else {
                    EmptyStateView(pickerItem: $pickerItem)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Редактор")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
        }
        .onChange(of: pickerItem) { _, item in
            guard let item else { return }
            Task {
                await viewModel.loadImage(from: item)
                pickerItem = nil
            }
        }
        .alert("Редактор", isPresented: alertBinding) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage ?? "")
        }
    }

    private func editor(image: UIImage) -> some View {
        VStack(spacing: 16) {
            Picker("Режим", selection: $viewModel.mode) {
                ForEach(EditorMode.allCases) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.segmented)

            EditorCanvasView(
                image: image,
                drawing: $viewModel.drawing,
                canvasSize: $viewModel.canvasSize,
                isDrawingEnabled: viewModel.mode == .drawing
            )

            if viewModel.mode == .filters {
                FilterControlsView(
                    pipeline: viewModel.pipeline,
                    onChange: viewModel.refreshPreview,
                    onReset: viewModel.resetFilters
                )
            }
        }
        .padding()
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        if viewModel.previewImage != nil {
            ToolbarItem(placement: .topBarLeading) {
                PhotosPicker(selection: $pickerItem, matching: .images) {
                    Image(systemName: "photo")
                }
            }
            ToolbarItemGroup(placement: .topBarTrailing) {
                if viewModel.mode == .drawing {
                    Button("Очистить", action: viewModel.clearDrawing)
                }
                Button("Сохранить") {
                    Task { await viewModel.save() }
                }
                .disabled(viewModel.isSaving)
            }
        }
    }

    private var alertBinding: Binding<Bool> {
        Binding(
            get: { viewModel.alertMessage != nil },
            set: { if !$0 { viewModel.alertMessage = nil } }
        )
    }
}
