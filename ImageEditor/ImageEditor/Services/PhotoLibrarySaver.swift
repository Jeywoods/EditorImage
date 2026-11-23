import Photos
import UIKit

protocol PhotoSaving {
    func save(_ image: UIImage) async throws
}

enum PhotoSaveError: LocalizedError {
    case accessDenied

    var errorDescription: String? {
        "Нет доступа к фототеке. Разрешите добавление фото в Настройках."
    }
}

final class PhotoLibrarySaver: PhotoSaving {
    func save(_ image: UIImage) async throws {
        let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
        guard status == .authorized || status == .limited else {
            throw PhotoSaveError.accessDenied
        }
        try await PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }
    }
}
