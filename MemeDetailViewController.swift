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
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var sentMemes: Meme!
    var indexOfMemes = Int()
    
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
    
    @IBAction func editMeme(sender: AnyObject) {
        self.performSegueWithIdentifier("editMeme", sender: self)
    }
    
    @IBAction func deleteMeme(sender: AnyObject) {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        //Remove From Array
        appDelegate.memes.removeAtIndex(indexOfMemes)
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    // HIDE STATUS BAR
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
  
    //PREPARE FOR SEGUE METHOD
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "editMeme") {
            let editMemeVC = segue.destinationViewController as! EditMemeViewController
            editMemeVC.editImage = self.sentMemes.originalImage
            editMemeVC.editTopText = self.sentMemes.topText
            editMemeVC.editBottomText = self.sentMemes.bottomText
        }
    }
}
