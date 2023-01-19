//
//  RecentsTVC.swift
//  TweeterTags
//
//

import UIKit

class RecentsTVC: UITableViewController {
    var searchs: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ud = UserDefaults.standard
        searchs = ud.stringArray(forKey: "searchs")!
    }
    
    // MARK: - Table view data source
    //Number of table partitions
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //Number of cells under partition
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "cellID"
         
        var cell = tableView.dequeueReusableCell(withIdentifier: cellid)
        if cell==nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellid)
        }
        cell?.textLabel!.text = self.searchs[indexPath.row]
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let txt = self.searchs[indexPath.row]
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "tweetstvc") as! TweetsTVC
        vc.twitterQueryText = txt
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
