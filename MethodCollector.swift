//
//  MethodCollector.swift
//  MemeMe_V02
//
//  Created by Eric Aichele on 4/13/16.
//  Copyright © 2016 Eric Aichele. All rights reserved.
//

import UIKit

extension EditMemeViewController {
    
    // PULL UP IMAGE PICKER
    func pickingImages(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    // PLACE IMAGE INTO IMAGEVIEW
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // GENERATE MEME
    func generateMemedImage() -> UIImage {
        // HIDE UI
        UIApplication.sharedApplication().statusBarHidden = true
        toolTop.hidden = true
        toolBottom.hidden = true
        
        // RENDER VIEW
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageView.frame.size.width, imageView.frame.size.height), false, 1)
        
        //UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height), afterScreenUpdates: true)
        
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // BRING BACK UI
        UIApplication.sharedApplication().statusBarHidden = false
        toolTop.hidden = false
        toolBottom.hidden = false
        
        return memedImage
    }
    
    // SAVE THE IMAGE
    func save() {
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imageView.image!, memedImage: generateMemedImage(), editedMeme: false)
        
        // ADD TO MEMES ARRAY IN APP DELGATE
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)    
    }
    
    // TEXT FORMATTING METHOD
    func formattingBlock(textBlock: UITextField, fieldName: String) {
        textBlock.defaultTextAttributes = memeTextAttributes
        textBlock.textAlignment = NSTextAlignment.Center
        textBlock.autocapitalizationType = .AllCharacters
        textBlock.attributedPlaceholder = NSAttributedString(string: fieldName, attributes: memeTextAttributes)
    }
    
    // CLICKING TEXT FIELD CLEARS TEXT
    func textFieldDidBeginEditing(textBlock: UITextField) {
        let textTest = textBlock.attributedPlaceholder
        if textTest == "TOP" || textTest == "BOTTOM" {
            textBlock.attributedPlaceholder = NSAttributedString(string: "", attributes: memeTextAttributes)
        }
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