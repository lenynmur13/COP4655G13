//
//  ImageHelper.swift
//  PupMatch
//
//  Created by Lenyn Murillo on 11/22/26.
//

import UIKit

enum ImageHelper {
    // shrink so the long side is maxSide, compress to JPEG, return base64 text
    static func base64(from image: UIImage, maxSide: CGFloat = 600, quality: CGFloat = 0.7) -> String? {
        let longest = max(image.size.width, image.size.height)
        let scale = min(1, maxSide / longest)    // never upscale small photos
        let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1                         // 1 pixel per point so the size is exact
        let resized = UIGraphicsImageRenderer(size: newSize, format: format).image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize)) // draw also applies the photo's rotation
        }

        guard var data = resized.jpegData(compressionQuality: quality) else { return nil }
        // keep lowering quality until the photo is under ~300 KB
        var q = quality
        while data.count > 300_000 && q > 0.2 {
            q -= 0.1
            if let smaller = resized.jpegData(compressionQuality: q) { data = smaller }
        }
        return data.base64EncodedString()
    }

    // turn stored base64 text back into an image; nil if missing or corrupt
    static func image(fromBase64 string: String?) -> UIImage? {
        guard let string, let data = Data(base64Encoded: string) else { return nil }
        return UIImage(data: data)
    }
}
