

import UIKit

extension UIImage {
    enum ImageFormat {
        case jpeg(compressionQuality: CGFloat)
        case png
    }

    func convertToData(withFormat format: ImageFormat) -> Data? {
        switch format {
        case .jpeg(let compressionQuality):
            return self.jpegData(compressionQuality: compressionQuality)
        case .png:
            return self.pngData()
        }
    }

    func rotate180Degrees() -> UIImage? {
        if let cgImage = self.cgImage, let colorSpace = cgImage.colorSpace, let context = CGContext(
            data: nil,
            width: Int(self.size.width),
            height: Int(self.size.height),
            bitsPerComponent: cgImage.bitsPerComponent,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: cgImage.bitmapInfo.rawValue
        ) {
            // Flip the image vertically and horizontally
            context.translateBy(x: self.size.width, y: self.size.height)
            context.rotate(by: .pi) // Rotate by 180 degrees
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))

            if let rotatedCGImage = context.makeImage() {
                return UIImage(cgImage: rotatedCGImage)
            }
        }

        return nil
    }
}

