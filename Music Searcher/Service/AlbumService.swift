//
//  AlbumHTTPService.swift
//  Discogs Searcher
//
//  Created by Денис Сластинин on 19.04.2022.
//

import Alamofire
import RxSwift
import Foundation
import SwiftUI

class AlbumHttpService: HttpService {
    var sessionManager: Session = Session.default
    
    func request(_ urlRequest: URLRequestConvertible) -> DataRequest {
        return sessionManager.request(urlRequest).validate(statusCode: 200..<400)
    }
}

enum AlbumHttpRouter {
    case get, post
}

extension AlbumHttpRouter: HttpRouter {
    
    var baseUrlString: String {
        return "https://api.discogs.com/database/search"
    }
    var path: String? {
        return nil
    }
    var method: HTTPMethod {
        switch self {
        case .get: return .get
        case .post: return .post
        }
    }
    var headers: HTTPHeaders? {
        return nil
    }
    var parameters: Parameters {
        return ["per_page": "5", "key": "gJUYhScQLSCpHbdwWOEx", "secret": "mfeCzxOLFBVgPKEofDhBqWBAbwzfvqja"]
    }
    var encoding: ParameterEncoding {
        return URLEncoding.default
    }
}
 
class AlbumService {
    private lazy var httpService = AlbumHttpService()
    let dataStoreManager = DataStoreManager()
    var albums = PublishSubject<[Album]>()
    var loadedAlbums: [Album] = []
    let bag = DisposeBag()
    
    func getAlbums(artist: String) {
        
        for page in stride(from: 1, to: 4, by: 2) {
            
            DispatchQueue.global(qos: .userInitiated).async {
                self.fetchAlbums(artist: artist, page: page, queue: 1)
            }
            
            DispatchQueue.global(qos: .background).async {
                self.fetchAlbums(artist: artist, page: page + 1, queue: 2)
            }
            
        }
        
    }
    
    func clearAlbums() {
        self.loadedAlbums = []
        self.albums.onNext([])
    }
    
    func fetchAlbums(artist: String, page: Int, queue: Int) {
        let parameters = ["artist": artist, "page": String(page)]
        do {
            try AlbumHttpRouter.get
                .request(usingHttpService: httpService, addParameters: parameters)
                .response { (result) in
                    guard let data = result.data else { return }
                    do {
                        let albumResponse = try JSONDecoder().decode(AlbumResponse.self, from: data)
                        let albums = albumResponse.results.map { _album -> Album in
                            var album = _album
                            album.queue = queue
                            return album
                        }
                        self.loadedAlbums += albums
                        self.albums.onNext(self.loadedAlbums)
                        for album in albums {
                            self.dataStoreManager.saveAlbum(album)
                        }
                    } catch {
                        let nserror = error as NSError
                        print(nserror.localizedDescription)
                    }
                }
        } catch {
            let nserror = error as NSError
            print(nserror.localizedDescription)
        }
    }
    
    func loadAlbumsFromStorage() {
        dataStoreManager.loadAlbums().forEach { album in
            loadedAlbums.append(
                Album(
                      queue: Int(album.queue),
                      country: album.country,
                      year: album.year,
                      format: album.format,
                      label: album.label,
                      genre: album.genre,
                      style: album.style,
                      id: Int(album.id),
                      title: album.title!,
                      coverImage: album.coverImage!
                     )
            )
        }
    }
    
}
