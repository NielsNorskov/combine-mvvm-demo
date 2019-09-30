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
    
    private var _imageSubscriber: AnyCancellable?
    
    override func prepareForReuse()
    {
        // Cancel the activity.
        _imageSubscriber?.cancel()
    }
    
    func configure(with itemVM: SearchItemViewModel)
    {
        // Set image to placeholder while downloading.
        thumbnailView.image = #imageLiteral(resourceName: "placeholder")
        
        // Bind view-model to UI elements.
        itemVM.title.assign(to: \.titleLabel.text, on: self).cancel()
        itemVM.thumbnailURL
            .compactMap{ return $0 }
            .sink { thumbnailURL in
                // Download image.
                self._imageSubscriber = URLSession.shared.fetchImage(for: thumbnailURL, placeholder: #imageLiteral(resourceName: "placeholder"))
                    .receive(on: DispatchQueue.main)
                    .assign(to: \.thumbnailView.image, on: self) }.cancel()
    }
}
