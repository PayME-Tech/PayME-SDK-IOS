//
//  Extension+String.swift
//  PayMESDK
//
//  Created by Minh Khoa on 24/06/2021.
//

import Foundation

extension String {
    func localize() -> String {
        let bundle = Bundle(for: PayME.self)
        let bundleURL = bundle.resourceURL?.appendingPathComponent("PayMESDK.bundle")
        let resourceBundle = Bundle(url: bundleURL!)
        let path = resourceBundle?.path(forResource: PayMEFunction.language, ofType: "lproj")
        let bundleLocalize = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundleLocalize!, value: "", comment: "")
    }

    func generateQRImage(withLogo logo: UIImage? = nil) -> UIImage? {
        let dataString = data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(dataString, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                guard let logoImage = logo?.cgImage else { return UIImage(ciImage: output) }
                if let finalOutput = output.combined(with: CIImage(cgImage: logoImage)) {
                    return UIImage(ciImage: finalOutput)
                }
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
}