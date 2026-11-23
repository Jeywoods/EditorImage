import PencilKit
import SwiftUI

/// Обёртка над PKCanvasView для SwiftUI.
struct DrawingCanvasView: UIViewRepresentable {
    @Binding var drawing: PKDrawing
    let isDrawingEnabled: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(drawing: $drawing)
    }

    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.drawingPolicy = .anyInput
        canvas.backgroundColor = .clear
        canvas.isOpaque = false
        canvas.overrideUserInterfaceStyle = .light
        canvas.delegate = context.coordinator
        context.coordinator.toolPicker.addObserver(canvas)
        return canvas
    }

    func updateUIView(_ canvas: PKCanvasView, context: Context) {
        if canvas.drawing != drawing {
            canvas.drawing = drawing
        }
        canvas.isUserInteractionEnabled = isDrawingEnabled

        let toolPicker = context.coordinator.toolPicker
        toolPicker.setVisible(isDrawingEnabled, forFirstResponder: canvas)
        if isDrawingEnabled {
            DispatchQueue.main.async { canvas.becomeFirstResponder() }
        } else {
            canvas.resignFirstResponder()
        }
    }

    final class Coordinator: NSObject, PKCanvasViewDelegate {
        let toolPicker = PKToolPicker()
        private var drawing: Binding<PKDrawing>

        init(drawing: Binding<PKDrawing>) {
            self.drawing = drawing
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            drawing.wrappedValue = canvasView.drawing
        }
    }
}
