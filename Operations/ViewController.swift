//
//  ViewController.swift
//  Operations
//
//  Created by Uy Nguyen on 5/17/20.
//  Copyright © 2020 Uy Nguyen. All rights reserved.
//

import UIKit


class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var lblPostTitle: UILabel!
    @IBOutlet weak var imgPostImage: UIImageView!
}

class ViewController: UIViewController {
    let urls = [
        (title: "Building your personal page with Hexo", url: "https://uynguyen.github.io/Post-Resources/Hexo/Cover.png"),
        (title: "Beta Test and TestFlight", url:  "https://uynguyen.github.io/Post-Resources/TestFlight/Cover.png"),
        (title: "iOS: Mix and Match", url: "https://uynguyen.github.io/Post-Resources/MixMatch/mix-match-banner.png"),
        (title: "Best practice: Core Data Concurrency", url: "https://uynguyen.github.io/Post-Resources/CoreDataConcurrency/banner.png"),
        (title: "Two weeks at Fossil Group in the US", url: "https://uynguyen.github.io/Post-Resources/Fossil_Group/Fossil_Group.jpg"),
        (title: "Integrate Google Drive to iOS app", url: "https://uynguyen.github.io/Post-Resources/GoogleDrive/GoogleDrive.png")
    ]
    
    @IBOutlet weak var tbPosts: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tbPosts.delegate = self
        tbPosts.dataSource = self
    }
}

extension ViewController: UITableViewDelegate {
    
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
        let data = urls[indexPath.row]
        URLSession.shared.dataTask(with: URL(string: data.url)!, completionHandler: { (data, res, error) in
            guard error == nil,
                let data = data else { return }
            DispatchQueue.main.async {
                cell.imgPostImage.contentMode = .scaleToFill
                cell.imgPostImage.image = UIImage(data: data)
            }
        }).resume()
        
        cell.lblPostTitle.text = data.title
        return cell
    }
}

