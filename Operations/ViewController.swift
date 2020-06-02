//
//  ViewController.swift
//  Operations
//
//  Created by Uy Nguyen on 5/17/20.
//  Copyright © 2020 Uy Nguyen. All rights reserved.
//

import UIKit
import CoreImage

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var lblPostTitle: UILabel!
    @IBOutlet weak var imgPostImage: UIImageView!
}

class ViewController: UIViewController {
    var urls = [(title: String, url: String)]()
    
    @IBOutlet weak var tbPosts: UITableView!
    private let queue = OperationQueue()
    private var operations: [IndexPath: [Operation]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setup()
        
        tbPosts.delegate = self
        tbPosts.dataSource = self
    }
    
    func setup() {
        let inputUrl = Bundle.main.url(forResource: "input", withExtension: "json")!
        do {
            let data = try Data(contentsOf: inputUrl)
            if let jsonDict = try JSONSerialization.jsonObject(with: data) as? [[String: String]] {
                self.urls = jsonDict.map { ($0.first!.key, $0.first!.value) }
            }
        } catch {
            
        }
    }
    
//    func grayScale(input: UIImage) -> UIImage? {
//        let context = CIContext(options: nil)
//        var inputImage = CIImage(image: input)
//
//        let filters = inputImage!.autoAdjustmentFilters()
//
//        for filter: CIFilter in filters {
//            filter.setValue(inputImage, forKey: kCIInputImageKey)
//            inputImage =  filter.outputImage
//        }
//
//        let cgImage = context.createCGImage(inputImage!, from: inputImage!.extent)
//        let currentFilter = CIFilter(name: "CIPhotoEffectTonal")
//        currentFilter!.setValue(CIImage(image: UIImage(cgImage: cgImage!)), forKey: kCIInputImageKey)
//
//        let output = currentFilter!.outputImage
//        let cgimg = context.createCGImage(output!, from: output!.extent)
//        return UIImage(cgImage: cgimg!)
//    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let operations = operations[indexPath] {
            for operation in operations {
                operation.cancel()
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath) as! PostTableViewCell
        let input = urls[indexPath.row]
        
//        Using GDC
//        DispatchQueue.global(qos: .background).async {
//            URLSession.shared.dataTask(with: URL(string: input.url)!, completionHandler: { (data, res, error) in
//                guard error == nil,
//                    let data = data,
//                    let image = UIImage(data: data) else { return }
//
//                let filteredImage = self.grayScale(input: image)
//                DispatchQueue.main.async {
//                    cell.lblPostTitle.text = input.title
//                    cell.imgPostImage.image = filteredImage
//                }
//            }).resume()
//        }
        
        
//      Using Operation instead
        let downloadOpt = DownloadImageOperation(url: URL(string: input.url)!)
        let grayScaleOpt = ImageFilterOperation()

        grayScaleOpt.addDependency(downloadOpt)
        grayScaleOpt.completionBlock = {
            DispatchQueue.main.async {
                cell.lblPostTitle.text = input.title
                cell.imgPostImage.image = grayScaleOpt.processedImage
            }
        }
        self.queue.addOperation(downloadOpt)
        self.queue.addOperation(grayScaleOpt)

        if let existingOperations = operations[indexPath] {
            for operation in existingOperations {
                operation.cancel()
            }
        }
        operations[indexPath] = [grayScaleOpt, downloadOpt]
        
        return cell
    }
}

