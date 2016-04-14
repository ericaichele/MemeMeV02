//
//  MemeCollectionViewController.swift
//  MemeMe_V02
//
//  Created by Eric Aichele on 4/13/16.
//  Copyright © 2016 Eric Aichele. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // EDIT BUTTONS. NOT READY YET
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.reloadData()
    }
    
    // IF NO MEMES, THEN GO MAKE SOME
    override func viewDidAppear(animated: Bool) {
        if appDelegate.memes.count == 0 {
            _ = self.storyboard
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("EditMemeVC") as! EditMemeViewController
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    // COLLECTION VIEW SETUP
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let CellID = "CollectionCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellID, forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = appDelegate.memes[indexPath.item]
        
        let imageView = UIImageView(image: meme.memedImage)
        cell.backgroundView = imageView
        cell.backgroundView?.contentMode = .ScaleAspectFit
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let memeDetail = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailVC") as! MemeDetailViewController
        memeDetail.sentMemes = appDelegate.memes[indexPath.row]
        self.navigationController!.pushViewController(memeDetail, animated: true)
    }
    
    @IBAction func addNewMeme(sender: AnyObject) {
        _ = self.storyboard
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("EditMemeVC") as! EditMemeViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    
}


