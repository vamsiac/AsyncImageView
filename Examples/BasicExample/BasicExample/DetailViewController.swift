//
//  DetailViewController.swift
//  BasicExample
//
//  Created by Vamsi Chaitanya on 10/23/16.
//  Copyright © 2016 Vamsi Anguluru. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create an image view programatically
        let asyncImageView = AsyncImageView(frame: self.view.frame)
        asyncImageView.contentMode = .scaleAspectFit
        //loading the image
        asyncImageView.imageURL = URL(string: "https://cdn.photographylife.com/wp-content/uploads/2012/02/Nikon-D800-Image-Sample-1.jpg")
        self.view.addSubview(asyncImageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
