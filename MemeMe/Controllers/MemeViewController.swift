//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Edgar Cobos on 2019-08-13.
//  Copyright © 2019 Edgar Cobos. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController {

    var meme: Meme!
    
    @IBOutlet weak var imageView: UIImageView!
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imageView.image = meme.memedImage
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
}
