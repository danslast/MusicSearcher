//
//  DataStoreService.swift
//  Discogs Searcher
//
//  Created by Денис Сластинин on 04.05.2022.
//

import CoreData

class DataStoreManager {
    
    // MARK: Core Data Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context: NSManagedObjectContext = persistentContainer.viewContext
    
    // MARK: CRUD
    
    func saveAlbum(_ album: Album) {
        
        let _album = AlbumDB(context: context)
        _album.id = Int32(album.id)
        _album.title = album.title
        _album.year = album.year
        _album.genre = album.genre
        _album.style = album.style
        _album.country = album.country
        _album.format = album.format
        _album.label = album.label
        _album.coverImage = album.coverImage
        _album.queue = Int32(album.queue!)

        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.localizedDescription)")
        }
    }
    
    func loadAlbums() -> [AlbumDB] {
        var albums: [AlbumDB] = []
        do {
            albums = try context.fetch(AlbumDB.fetchRequest())
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.localizedDescription)")
        }
        return albums
    }
    
    func deleteAlbums() {
        do {
            let albums = try context.fetch(AlbumDB.fetchRequest())
            for album in albums {
                context.delete(album)
            }
            saveContext()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.localizedDescription)")
        }
    }
    
    func saveContext() {
        if  context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
