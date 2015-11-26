//
//  FeedItem.swift
//  PhotoExchange
//
//  Created by Rick Williams on 11/5/15.
//  Copyright (c) 2015 Rick Williams. All rights reserved.
//

import Foundation
import CoreData


@objc(FeedItem)
class FeedItem: NSManagedObject {

    @NSManaged var caption: String
    @NSManaged var image: NSData

}
