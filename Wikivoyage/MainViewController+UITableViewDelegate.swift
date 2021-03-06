//
//  MainViewController+UITableViewDelegate.swift
//  Wikivoyage
//
//  Created by Ben Meline on 10/6/15.
//  Copyright (c) 2015 Ben Meline. All rights reserved.
//

import UIKit

extension MainViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let searchResult = searchResults[indexPath.row]
        selectedSearchResult = searchResult
        performSegueWithIdentifier(webSegueIdentifier, sender: self)
        mainView.dismissKeyboard()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        mainView.dismissKeyboard()
    }
}
