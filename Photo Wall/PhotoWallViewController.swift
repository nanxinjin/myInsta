//
//  PhotoWallViewController.swift
//  Myinsta
//
//  Created by Nanxin Jin on 3/19/17.
//  Copyright © 2017 Nanxin Jin. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class PhotoWallViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var posts: [PFObject]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        load()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        load()
    }
    
    @IBAction func onLogout(_ sender: Any) {
        logout()
    }
    
    func logout() {
        PFUser.logOutInBackground { (error: Error?) in
            if error == nil {
                print("Successfully logged out")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLogout"), object: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let posts = posts {
            return posts.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WallCell", for: indexPath) as! WallCell
        
        cell.post = posts![indexPath.section]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let label = UILabel(frame: CGRect(x: 8, y: 12, width: 220, height: 30))
        let post = self.posts![section]
        
        let author = post["author"] as! PFUser
        label.text = author.username!

        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func load() {
        
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                self.posts = posts
                self.tableView.reloadData()
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
