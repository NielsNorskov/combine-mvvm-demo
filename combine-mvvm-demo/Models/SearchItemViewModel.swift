//
//  SearchItemViewModel.swift
//  combine-mvvm-demo
//
//  Created by Niels Nørskov on 30/09/2019.
//  Copyright © 2019 Niels Nørskov. All rights reserved.
//

import Foundation
import Combine

struct SearchItemListViewModel
{
    let searchItemList: [SearchItemViewModel]
}

extension SearchItemListViewModel
{
    init(_ items: [SearchItem])
    {
        searchItemList = items.map{ SearchItemViewModel($0) }
    }
    
    func item(at index: Int) -> SearchItemViewModel
    {
        return searchItemList[index]
    }
}

struct SearchItemViewModel
{
    let searchItem: SearchItem
}

extension SearchItemViewModel
{
    init(_ item: SearchItem)
    {
        searchItem = item
    }
    
    var title: AnyPublisher<String?, Never> {
        return Just(searchItem.title).eraseToAnyPublisher()
    }
    
    var description: AnyPublisher<String?, Never> {
        return Just(searchItem.description).eraseToAnyPublisher()
    }
    
    var thumbnailURL: AnyPublisher<URL?, Never> {
        return Just(searchItem.thumbnailURL).eraseToAnyPublisher()
    }
}
