//
//  SearchItemViewModel.swift
//  combine-mvvm-demo
//
//  Created by Niels Nørskov on 30/09/2019.
//  Copyright © 2019 Niels Nørskov. All rights reserved.
//

import Foundation
import Combine

struct SearchItemViewModel
{
    let item: SearchItem
}

extension SearchItemViewModel
{
    init(_ item: SearchItem)
    {
        self.item = item
    }
    
    var title: AnyPublisher<String?, Never> {
        return Just(item.title).eraseToAnyPublisher()
    }
    
    var description: AnyPublisher<String?, Never> {
        return Just(item.description).eraseToAnyPublisher()
    }
    
    var thumbnailURL: AnyPublisher<URL?, Never> {
        return Just(item.thumbnailURL).eraseToAnyPublisher()
    }
}
