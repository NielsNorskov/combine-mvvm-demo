//
//  DetailViewController.swift
//  combine-mvvm-demo
//
//  Created by Niels Nørskov on 30/09/2019.
//  Copyright © 2019 Niels Nørskov. All rights reserved.
//

import UIKit
import Combine

class DetailViewController: UIViewController
{    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var searchItemVM: SearchItemViewModel?
    
    // Subscriber for downloading image.
    private var _imageSubscriber: AnyCancellable?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        guard let searchItemVM = searchItemVM else {
            assertionFailure("SearchItemViewModel must be set before presenting!")
            return
        }
        
        // Bind view-model to UI elements.
        searchItemVM.title.assign(to: \.title, on: self).cancel()
        searchItemVM.title.assign(to: \.titleLabel.text, on: self).cancel()
        searchItemVM.description.assign(to: \.descriptionLabel.text, on: self).cancel()
        searchItemVM.thumbnailURL
            .compactMap{ return $0 }
            .sink { thumbnailURL in
                // Download image.
                self._imageSubscriber = URLSession.shared.fetchImage(for: thumbnailURL,
                                                                     placeholder: UIImage(systemName: "photo"))
                    .receive(on: DispatchQueue.main)
                    .assign(to: \.imageView.image, on: self) }.cancel()
    }
}
