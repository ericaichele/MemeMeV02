//
//  EditMemeViewController.swift
//  MemeMe_V02
//
//  Created by Eric Aichele on 4/13/16.
//  Copyright © 2016 Eric Aichele. All rights reserved.
//

import UIKit

class EditMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var toolTop: UIToolbar!
    @IBOutlet weak var toolBottom: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var sentMemes: [Meme]!
    var editImage: UIImage!
    var editTopText: String!
    var editBottomText: String!
    
    var memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "Impact", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]
 
    //OVERRIDES
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // PROPERTIES
        view.backgroundColor = UIColor.grayColor()
        shareButton.enabled = false
        
        // LOAD EDIT ITEMS
        topText.text = editTopText
        bottomText.text = editBottomText
        imageView.image = editImage
        
        // DELEGATES
        self.topText.delegate = self
        self.bottomText.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // ACTIVATE CAMERA BUTTON
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        sentMemes = appDelegate.memes
        formattingBlock(topText, fieldName: "TOP")
        formattingBlock(bottomText, fieldName: "BOTTOM")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    // HIDE STATUS BAR
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // IMAGE PICKER ACTIONS
    @IBAction func pickImageAlbum(sender: AnyObject) {
        pickingImages(.PhotoLibrary)
    }
    
    @IBAction func pickImageCamera(sender: AnyObject) {
        pickingImages(.Camera)
    }
    
    // SHARE BUTTON ACTIONS
    @IBAction func shareButtonPress(sender: AnyObject) {
        let memedImage = self.generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = {
            (activity: String?, completed: Bool, items: [AnyObject]?, error: NSError?) -> Void in
            if completed {
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    @IBAction func DoneButtonAction(sender: AnyObject) {
        if sentMemes.count == 0 {
            let alertController = UIAlertController(title: "Bummer.", message: "You don't have any memes made yet.", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "Make a Meme", style: .Default) { (action) in
            }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // FONT ACTION SHEET
    @IBAction func changeFont(sender: AnyObject) {
        // SETUP ACTION SHEET
        let optionMenu = UIAlertController(title: nil, message: "Choose a New Fonts", preferredStyle: .ActionSheet)
        let changeHelvetica = UIAlertAction(title: "Helvetica Bold", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.memeTextAttributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)
            self.formattingBlock(self.topText, fieldName: "TOP")
            self.formattingBlock(self.bottomText, fieldName: "BOTTOM")
            print("\(self.memeTextAttributes[NSFontAttributeName])")
            
        })
        let changeOptima = UIAlertAction(title: "Optima", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.memeTextAttributes[NSFontAttributeName] = UIFont(name: "Optima-Regular", size: 40)
            self.formattingBlock(self.topText, fieldName: "TOP")
            self.formattingBlock(self.bottomText, fieldName: "BOTTOM")
            print("\(self.memeTextAttributes[NSFontAttributeName])")
        })
        let changeImpact = UIAlertAction(title: "Impact", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.memeTextAttributes[NSFontAttributeName] = UIFont(name: "Impact", size: 40)
            self.formattingBlock(self.topText, fieldName: "TOP")
            self.formattingBlock(self.bottomText, fieldName: "BOTTOM")
            print("\(self.memeTextAttributes[NSFontAttributeName])")
        })
        
        // POPULATE ACTION SHEET
        optionMenu.addAction(changeHelvetica)
        optionMenu.addAction(changeOptima)
        optionMenu.addAction(changeImpact)
        
        presentViewController(optionMenu, animated: true, completion: nil)
    }
  
}