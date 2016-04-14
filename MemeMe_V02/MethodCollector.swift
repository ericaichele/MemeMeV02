//
//  MethodCollector.swift
//  MemeMe_V02
//
//  Created by Eric Aichele on 4/13/16.
//  Copyright © 2016 Eric Aichele. All rights reserved.
//

import Foundation
import UIKit

extension EditMemeViewController {
    
    // PULL UP IMAGE PICKER
    func pickingImages(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        //UIApplication.sharedApplication().statusBarHidden = true
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    // PLACE IMAGE INTO IMAGEVIEW
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        shareButton.enabled = true
        introText.hidden = true
    }
    
    // GENERATE MEME
    func generateMemedImage() -> UIImage {
        // HIDE UI
        //UIApplication.sharedApplication().statusBarHidden = true
        toolTop.hidden = true
        toolBottom.hidden = true
        
        // RENDER VIEW
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // BRING BACK UI
        //UIApplication.sharedApplication().statusBarHidden = false
        toolTop.hidden = false
        toolBottom.hidden = false
        
        return memedImage
    }
    
    // SAVE THE IMAGE
    func save() {
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
        
        // ADD TO MEMES ARRAY IN APP DELGATE
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    // TEXT FORMATTING METHOD
    func formattingBlock(textBlock: UITextField, fieldName: String) {
        textBlock.defaultTextAttributes = memeTextAttributes
        textBlock.textAlignment = NSTextAlignment.Center
        textBlock.text = "\(fieldName)"
    }
    
    
    // KEYBOARD METHODS
    func keyboardWillShow(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y = getKeyboardHeight(notification) * -1
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y = 0
        }
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditMemeViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditMemeViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    // RETURN BUTTON CLOSES KEYBOARD AND DEACTIVATES TEXT FIELD
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
   
}