
//
//  MemeTableViewController.swift
//  MemeMe_V02
//
//  Created by Eric Aichele on 4/13/16.
//  Copyright © 2016 Eric Aichele. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    // GLOBALS
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var selectedMemes = [Meme]()
    
    // OVERRIDES
    override func viewDidLoad() {
        super.viewDidLoad()
        // EDIT BUTTONS. NOT READY YET
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    // IF NO MEMES, THEN GO MAKE SOME
    override func viewDidAppear(animated: Bool) {
        if appDelegate.memes.count == 0 {
            _ = self.storyboard
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("EditMemeVC") as! EditMemeViewController
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    // TABLE VIEW SETUP
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell")!
        let meme = self.appDelegate.memes[indexPath.row]
        
        cell.imageView!.image = meme.memedImage
        cell.imageView?.contentMode = .ScaleAspectFit
        cell.textLabel!.text = "\(meme.topText)" + " " + "\(meme.bottomText)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let memeDetails = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailVC") as! MemeDetailViewController
        memeDetails.sentMemes = self.appDelegate.memes[indexPath.row]
        memeDetails.indexOfMemes = indexPath.row
        
        self.navigationController!.pushViewController(memeDetails, animated: true)
    }
    @IBAction func newMeme(sender: AnyObject) {
        _ = self.storyboard
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("EditMemeVC") as! EditMemeViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    // DELETE SWIPE SETUP
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // SWIPE TO DELETE
    override func tableView(tableView: UITableView, commitEditingStyle editingStype: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        appDelegate.memes.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        tableView.reloadData()
    }
    
    
}
