//
//  ImageFilterOperation.swift
//  Operations
//
//  Created by Uy Nguyen on 5/17/20.
//  Copyright © 2020 Uy Nguyen. All rights reserved.
//

import UIKit
import CoreImage

class ImageFilterOperation: Operation {
    let context = CIContext(options: nil)
    var processedImage: UIImage?
    
    func grayScale(input: UIImage) -> UIImage? {
        var inputImage = CIImage(image: input)
        
        let filters = inputImage!.autoAdjustmentFilters()

        for filter: CIFilter in filters {
            filter.setValue(inputImage, forKey: kCIInputImageKey)
            inputImage =  filter.outputImage
        }
        
        let cgImage = context.createCGImage(inputImage!, from: inputImage!.extent)
        let currentFilter = CIFilter(name: "CIPhotoEffectTonal")
        currentFilter!.setValue(CIImage(image: UIImage(cgImage: cgImage!)), forKey: kCIInputImageKey)

        let output = currentFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        return UIImage(cgImage: cgimg!)
    }
    
    override func main() {
        guard !isCancelled else { return }
        
        let dependencyImage = self.dependencies
            .compactMap { $0 as? DownloadImageOperation }
            .first
        
        if let image = dependencyImage?.outputImage {
            guard !isCancelled else { return }
            self.processedImage = self.grayScale(input: image)
        }
    }
}
