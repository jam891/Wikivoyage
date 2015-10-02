//
//  LocationWebViewController.swift
//  Wikivoyage
//
//  Created by Ben Meline on 9/11/15.
//  Copyright (c) 2015 Ben Meline. All rights reserved.
//

import Alamofire
import SwiftyJSON
import MagicalRecord

class LocationWebViewController: StaticWebViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    @IBAction func favorite(sender: AnyObject) {
        favoritePage()
        let button = sender as! UIBarButtonItem
        button.tintColor = .redColor()
    }
    
    @IBAction func download(sender: AnyObject) {
        downloadPage()
        let button = sender as! UIBarButtonItem
        button.tintColor = .redColor()
    }
    
    func favoritePage() {
        let id = NSNumber(integer: self.pageId)
        if let savedPage = SavedPage.MR_findFirstByAttribute("id", withValue: id) {
            savedPage.favorite = true
        } else {
            let savedPage = SavedPage.MR_createEntity()
            savedPage.title = self.pageTitle
            savedPage.id = self.pageId
            savedPage.favorite = true
            savedPage.offline = false
        }
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    func downloadPage() {
        Alamofire.request(.GET, "http://en.wikivoyage.org/w/api.php", parameters: ["action": "parse", "pageid": pageId, "prop": "text", "mobileformat": "", "noimages": "", "format": "json"]).responseJSON() {
            (_, _, data, error) in
            if(error != nil) {
                NSLog("Error: \(error)")
            } else {
                let json = JSON(data!)
                
                // Check if it's already saved and save HTML
                let id = NSNumber(integer: self.pageId)
                if let savedPage = SavedPage.MR_findFirstByAttribute("id", withValue: id) {
                    savedPage.html = json["parse"]["text"]["*"].stringValue
                    savedPage.offline = true
                } else {
                    let savedPage = SavedPage.MR_createEntity()
                    savedPage.title = self.pageTitle
                    savedPage.id = self.pageId
                    savedPage.html = json["parse"]["text"]["*"].stringValue
                    savedPage.favorite = false
                    savedPage.offline = true
                }
                
                NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
            }
        }
    }
}