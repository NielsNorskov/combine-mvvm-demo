//
//  SearchResultCell.swift
//  mvc-demo
//
//  Created by Niels Nørskov on 25/09/2019.
//  Copyright © 2019 Niels Nørskov. All rights reserved.
//

import UIKit
import Combine

class SearchResultCell: UITableViewCell
{
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    private var _subscriber: AnyCancellable?
    
    override func prepareForReuse()
    {
        // Cancel the activity.
        _subscriber?.cancel()
    }
    
    func configure(with item: SearchItem)
    {
        titleLabel.text = item.title ?? "Untitled"
        thumbnailView.image = #imageLiteral(resourceName: "placeholder")
        if let thumbnailURL = item.thumbnailURL {
            _subscriber = URLSession.shared.fetchImage(for: thumbnailURL, placeholder: #imageLiteral(resourceName: "placeholder"))
                .receive(on: DispatchQueue.main)
                .assign(to: \.thumbnailView.image, on: self)
        }
    }
}
