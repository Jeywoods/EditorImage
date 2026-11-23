import CoreImage
import Observation
import PencilKit
import PhotosUI
import SwiftUI

enum EditorMode: String, CaseIterable, Identifiable {
    case filters = "Фильтры"
    case drawing = "Рисование"

    var id: Self { self }
}

@MainActor
@Observable
final class ImageEditorViewModel {
    let pipeline: FilterPipeline
    var mode: EditorMode = .filters
    var drawing = PKDrawing()
    var canvasSize = CGSize.zero
    var alertMessage: String?
    private(set) var previewImage: UIImage?
    private(set) var isSaving = false

    private var originalImage: UIImage?
    private var previewSource: CIImage?

    private let renderer: ImageRendering
    private let composer: DrawingComposing
    private let saver: PhotoSaving

    private let previewMaxSide: CGFloat = 1500

    init(pipeline: FilterPipeline, renderer: ImageRendering, composer: DrawingComposing, saver: PhotoSaving) {
        self.pipeline = pipeline
        self.renderer = renderer
        self.composer = composer
        self.saver = saver
    }

    func loadImage(from item: PhotosPickerItem) async {
        guard let data = try? await item.loadTransferable(type: Data.self),
              let image = UIImage(data: data) else {
            alertMessage = "Не удалось загрузить фото"
            return
        }
        let fullImage = image.normalized()
        originalImage = fullImage
        previewSource = CIImage(image: fullImage.resized(maxSide: previewMaxSide))
        pipeline.reset()
        drawing = PKDrawing()
        mode = .filters
        refreshPreview()
    }

    /// Фильтры применяются к уменьшенной копии, чтобы слайдеры работали плавно.
    func refreshPreview() {
        guard let source = previewSource else { return }
        previewImage = renderer.render(pipeline.apply(to: source))
    }

    func resetFilters() {
        pipeline.reset()
        refreshPreview()
    }

    func clearDrawing() {
        drawing = PKDrawing()
    }

    func save() async {
        guard let originalImage, let source = CIImage(image: originalImage),
              let filtered = renderer.render(pipeline.apply(to: source)) else { return }

        isSaving = true
        defer { isSaving = false }

        let result = composer.compose(image: filtered, drawing: drawing, canvasSize: canvasSize)
        do {
            try await saver.save(result)
            alertMessage = "Фото сохранено в библиотеку"
        } catch {
            alertMessage = error.localizedDescription
        }
    }
}
