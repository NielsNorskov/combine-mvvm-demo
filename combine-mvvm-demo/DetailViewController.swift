//
//  DetailViewController.swift
//  mvc-demo
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
    
    var itemVM: SearchItemViewModel?
    
    // Subscriber for downloading image.
    private var _imageSubscriber: AnyCancellable?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        guard let itemVM = itemVM else {
            assertionFailure("SearchItemViewModel must be set before presenting!")
            return
        }
        
        // Bind view-model to UI elements.
        //
        itemVM.title.assign(to: \.title, on: self).cancel()
        itemVM.title.assign(to: \.titleLabel.text, on: self).cancel()
        itemVM.description.assign(to: \.descriptionLabel.text, on: self).cancel()
        itemVM.thumbnailURL
            .compactMap{ return $0 }
            .sink { thumbnailURL in
                self._imageSubscriber = URLSession.shared.fetchImage(for: thumbnailURL, placeholder: #imageLiteral(resourceName: "placeholder"))
                    .receive(on: DispatchQueue.main)
                    .assign(to: \.imageView.image, on: self) }.cancel()
    }
}
