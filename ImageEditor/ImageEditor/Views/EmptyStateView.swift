import PhotosUI
import SwiftUI

struct EmptyStateView: View {
    @Binding var pickerItem: PhotosPickerItem?

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)
            Text("Выберите фото для редактирования")
                .foregroundStyle(.secondary)
            PhotosPicker(selection: $pickerItem, matching: .images) {
                Text("Выбрать фото")
                    .padding(.horizontal, 8)
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
