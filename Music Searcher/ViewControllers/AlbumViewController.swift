//
//  TableViewController.swift
//  Discogs Searcher
//
//  Created by Денис Сластинин on 18.04.2022.
//

import UIKit
import RxSwift
import RxCocoa

class AlbumViewController: UITableViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let albumServise = AlbumService()
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        
        tableView.dataSource = nil
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        bindTableData ()
        
        albumServise.loadAlbumsFromStorage()
        albumServise.albums.onNext(albumServise.loadedAlbums)
    }
    
    func configureSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search album"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    func bindTableData () {
        albumServise.albums.bind(
            to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self
        )) { row, album, cell in
            var content = cell.defaultContentConfiguration()
            content.text = album.title
            content.secondaryText = album.year
            cell.contentConfiguration = content
            switch album.queue {
            case 1: cell.backgroundColor = .red.withAlphaComponent(0.5)
            case 2: cell.backgroundColor = .blue.withAlphaComponent(0.5)
            default: break
            }
        }.disposed(by: bag)
        
        tableView.rx.modelSelected(Album.self).bind { album in
            print(album.id)
        }.disposed(by: bag)
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "details", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let detailViewController = segue.destination as? DetailedViewController
                detailViewController?.album = albumServise.loadedAlbums[indexPath.row]
            }
        }
    }

}

extension AlbumViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchBar.text ?? ""
        self.albumServise.clearAlbums()
        albumServise.getAlbums(artist: query)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        for album in albumServise.loadedAlbums {
//            albumServise.dataStoreManager.saveAlbum(album)
//        }
        self.albumServise.clearAlbums()
        self.albumServise.dataStoreManager.deleteAlbums()
    }
    
}
