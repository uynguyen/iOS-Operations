//
//  DownloadImageOperation.swift
//  Operations
//
//  Created by Uy Nguyen on 5/17/20.
//  Copyright © 2020 Uy Nguyen. All rights reserved.
//

import UIKit

//class DownloadImageOperation: Operation {
//    let url: URL
//    var outputImage: UIImage?
//
//    init(url: URL) {
//        self.url = url
//    }
//
//    override func main() {
//        guard !isCancelled else { return }
//
//        URLSession.shared.dataTask(with: self.url, completionHandler: { (data, res, error) in
//            guard error == nil,
//                let data = data else { return }
//
//            self.outputImage = UIImage(data: data)
//        }).resume()
//    }
//}

class DownloadImageOperation: AsyncOperation {
    let url: URL
    var outputImage: UIImage?
    private var task: URLSessionDataTask?

    init(url: URL) {
        self.url = url
    }

    override func main() {
        self.task = URLSession.shared.dataTask(with: self.url, completionHandler: { [weak self] (data, res, error) in
            guard let `self` = self else { return }

            defer { self.state = .finished }

            guard !self.isCancelled else { return }

            guard error == nil,
                let data = data else { return }

            self.outputImage = UIImage(data: data)
        })
        task?.resume()
    }

    override func cancel() {
        super.cancel()
        task?.cancel()
    }
}

