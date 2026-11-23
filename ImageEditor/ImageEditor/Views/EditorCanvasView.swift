import PencilKit
import SwiftUI

/// Изображение с холстом PencilKit поверх него.
/// Холст точно совпадает с границами изображения.
struct EditorCanvasView: View {
    let image: UIImage
    @Binding var drawing: PKDrawing
    @Binding var canvasSize: CGSize
    let isDrawingEnabled: Bool

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .overlay {
                GeometryReader { proxy in
                    DrawingCanvasView(drawing: $drawing, isDrawingEnabled: isDrawingEnabled)
                        .onAppear { canvasSize = proxy.size }
                        .onChange(of: proxy.size) { _, size in canvasSize = size }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
