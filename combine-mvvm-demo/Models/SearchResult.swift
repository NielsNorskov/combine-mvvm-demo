//
//  SearchResult.swift
//  combine-mvvm-demo
//
//  Created by Niels Nørskov on 24/09/2019.
//  Copyright © 2019 Niels Nørskov. All rights reserved.
//

import Foundation

struct SearchResult: Codable
{
    let collection: Collection
}

struct Collection: Codable
{
    let items: [SearchItem]
}

struct SearchItem: Codable
{
    let data: [SearchData]
    let links: [Link]?
}

/// Extension for accessing nested optional data directly on SearchItem.
extension SearchItem
{
    var title: String? {
        return data.count > 0 ? data[0].title : nil
    }
    
    var description: String? {
        return data.count > 0 ? data[0].description : nil
    }
    
    var nasaID: String? {
        return data.count > 0 ? data[0].nasa_id : nil
    }
    
    var mediaType: String? {
        return data.count > 0 ? data[0].media_type : nil
    }
    
    var thumbnailURL: URL? {
        guard let links = links, links.count > 0 else {return nil}
        guard let href = links[0].href else {return nil}
        return URL(string: href)
    }
}

struct SearchData: Codable
{
    let title: String?
    let description: String?
    let media_type: String?
    let nasa_id: String?
}

struct Link: Codable
{
    let href: String?
    let render: String?
}

