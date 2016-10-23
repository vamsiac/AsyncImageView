//
//  ViewController.swift
//  BasicExample
//
//  Created by Vamsi Chaitanya on 10/20/16.
//  Copyright © 2016 Vamsi Anguluru. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    public enum SegueIdentifiers: Int {
        case storyBoardExample
        case onlyCodeExample
    }
    
    var viewControllers = ["Load in storyboard", "Load programatically"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK:- Table Delegate methods

extension ViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case SegueIdentifiers.storyBoardExample.rawValue:
            //Show stroyboard example
            if let storyboardExampleVc = self.storyboard?.instantiateViewController(withIdentifier: "StoryBoardExampleVC") {
                self.navigationController?.pushViewController(storyboardExampleVc, animated: true)
            }
            
        case SegueIdentifiers.onlyCodeExample.rawValue:
            //Show Loading programatically example
            if let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") {
                self.navigationController?.pushViewController(detailViewController, animated: true)
            }
            
        default: break
        }
        
    }
}

//MARK:- Table Datasource methods

extension ViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = viewControllers[indexPath.row]
        
        return cell
    }
}
