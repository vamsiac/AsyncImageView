//
//  StoryBoardExampleVC.swift
//  BasicExample
//
//  Created by Vamsi Chaitanya on 10/23/16.
//  Copyright © 2016 Vamsi Anguluru. All rights reserved.
//

import UIKit

class StoryBoardExampleVC: UIViewController {

    @IBOutlet var asyncImageView: AsyncImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loadImage(_ sender: AnyObject) {
        asyncImageView.imageURL = URL(string: "https://cdn.photographylife.com/wp-content/uploads/2012/02/Nikon-D800-Image-Sample-1.jpg")
    }

}
