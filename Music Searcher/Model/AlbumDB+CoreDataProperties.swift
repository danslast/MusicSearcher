//
//  AlbumDB+CoreDataProperties.swift
//  Discogs Searcher
//
//  Created by Денис Сластинин on 04.05.2022.
//
//

import Foundation
import CoreData


extension AlbumDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlbumDB> {
        return NSFetchRequest<AlbumDB>(entityName: "Album")
    }

    @NSManaged public var title: String?
    @NSManaged public var year: String?
    @NSManaged public var country: String?
    @NSManaged public var format: [String]?
    @NSManaged public var style: [String]?
    @NSManaged public var label: [String]?
    @NSManaged public var genre: [String]?
    @NSManaged public var coverImage: String?
    @NSManaged public var id: Int32
    @NSManaged public var queue: Int32

}

extension AlbumDB : Identifiable {

}
