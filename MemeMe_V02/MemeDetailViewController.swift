//
//  MemeDetailViewController.swift
//  MemeMe_V02
//
//  Created by Eric Aichele on 4/13/16.
//  Copyright © 2016 Eric Aichele. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var imageDetail: UIImageView!
    
    var sentMemes: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // HIDE TAB BAR
        self.tabBarController?.tabBar.hidden = true
        
        // SET UIIMAGE VIEW, hopefully.
        self.imageDetail!.image = self.sentMemes.memedImage
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }    
}
