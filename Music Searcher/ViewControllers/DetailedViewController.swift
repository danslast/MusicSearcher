//
//  ViewController.swift
//  Discogs Searcher
//
//  Created by Денис Сластинин on 18.04.2022.
//

import UIKit

class DetailedViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsTable: UITableView!
    @IBOutlet weak var coverImage: UIImageView!
    
    var album: Album!
    var albumDetails: [(String, String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = album.title
        detailsTable.delegate = self
        detailsTable.dataSource = self
        albumDetails = album.mapToArray(album)
    }
}

extension DetailedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = albumDetails[indexPath.row].0
        content.secondaryText = albumDetails[indexPath.row].1
        coverImage.load(url: URL(string: album.coverImage)!)
        cell.contentConfiguration = content
        
        return cell
    }

}


