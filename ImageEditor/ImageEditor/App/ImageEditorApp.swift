import SwiftUI

@main
struct ImageEditorApp: App {
    @State private var viewModel: ImageEditorViewModel

    @MainActor
    init() {
        let pipeline = FilterPipeline(filters: [
            HueAdjustFilter(),
            ColorControlsFilter(),
            VignetteFilter()
        ])
        _viewModel = State(initialValue: ImageEditorViewModel(
            pipeline: pipeline,
            renderer: CIImageRenderer(),
            composer: DrawingComposer(),
            saver: PhotoLibrarySaver()
        ))
    }

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
