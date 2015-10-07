//
//  FavoritesTableViewController.swift
//  Wikivoyage
//
//  Created by Ben Meline on 8/28/15.
//  Copyright (c) 2015 Ben Meline. All rights reserved.
//

import UIKit
import MagicalRecord

class FavoritesTableViewController: UITableViewController {

    var favoritePages = [SavedPage]()
    
    private let tableRowHeight: CGFloat = 60
    private let cellIdentifier = "FavoritePage"
    private let segueIdentifier = "ShowWeb"
    private let placeholder = UIImage(named: Images.placeholder)!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = tableRowHeight
        tableView.tableFooterView = UIView(frame: CGRectZero)
        clearsSelectionOnViewWillAppear = false
        navigationItem.rightBarButtonItem = editButtonItem()
        favoritePages = SavedPage.MR_findByAttribute("favorite", withValue: true, andOrderBy: "title", ascending: true) as! [SavedPage]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Need this to clear on back swipe
        if let row = tableView.indexPathForSelectedRow() {
            tableView.deselectRowAtIndexPath(row, animated: animated)
        }
    }

    // MARK: - Table View Data Source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePages.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! LocationTableViewCell
        let favoritePage = favoritePages[indexPath.row]
        
        cell.title.text = favoritePage.title
        
        // If there's a thumbnail URL set URL, otherwise it's nil
        let url = (favoritePage.thumbnailURL != nil) ? NSURL(string: favoritePage.thumbnailURL!) : nil
        cell.thumbnail.sd_setImageWithURL(url, placeholderImage: placeholder)
        
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let favoritePage = favoritePages[indexPath.row]
            if favoritePage.offline == true {
                // If the page is also offline, only update favorite property
                favoritePage.favorite = false
                favoritePages.removeAtIndex(indexPath.row)
            } else {
                favoritePages.removeAtIndex(indexPath.row).MR_deleteEntity()
            }
            NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }

    // MARK: - Table View Delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let favoritePage = favoritePages[indexPath.row]
        performSegueWithIdentifier(segueIdentifier, sender: favoritePage)
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueIdentifier {
            let vc = segue.destinationViewController as! LocationWebViewController
            let favoritePage = sender as! SavedPage
            vc.pageId = Int(favoritePage.id)
            vc.pageTitle = favoritePage.title
        }
    }
}
