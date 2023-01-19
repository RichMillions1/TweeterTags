//
//  TweetsTVC.swift
//  TweeterTags
//
//

import Foundation
import UIKit

class TweetsTVC : UITableViewController,UITextFieldDelegate {
    
    var tweets = [[TwitterTweet]]()
    var twitterQueryText = "#ucd"
    @IBOutlet weak var twitterQueryTextField : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refresh()
    }
    
    @objc func refresh(){
        let request = TwitterRequest(search: twitterQueryText, count: 8)
        request.fetchTweets { (ts) -> Void in
            DispatchQueue.main.async { [self] () -> Void in
                if ts.count != 0 {
                    self.tweets.removeAll()
                    // add to tweets
                    self.tweets.append(ts)
                    self.didSet()
                }
            }
        }
    }
    
    @objc func didSet(){
        // update tableview
        self.tableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        twitterQueryText = textField.text!
        textField.resignFirstResponder();
        
        let ud = UserDefaults.standard
        var searchs = ud.array(forKey: "searchs")
 
        if searchs != nil {
            searchs?.append(twitterQueryText)
            ud.removeObject(forKey: "searchs")
            ud.set(searchs,forKey: "searchs")
        } else {
            var arr: [String] = []
            arr.append(twitterQueryText)
            ud.set(arr,forKey: "searchs")
        }
        ud.synchronize()
        self.refresh()
        return true;
    }
    
    // MARK: - Table view data source
    //Number of table partitions
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }
    
    //Number of cells under partition
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    //Return to Custom Cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier : String = "tweetTVCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TweetTVCell
        let tweet = tweets[indexPath.section][indexPath.row]
        let url = tweet.user.profileImageURL
        if url?.absoluteString == "http://abs.twim.com/sticky/default_profile_images/default_profile_normal.png" {
            cell.tweetAvatarImageView.image = UIImage(named: "defaulthead")
        }else{
            let imgdata = try! Data(contentsOf: url!)
            let newImage = UIImage(data: imgdata)
            
            cell.tweetAvatarImageView.image = newImage
        }
        cell.tweetScreenNameLabel.text = tweet.user.screenName
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm aaa"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        cell.tweetCreatedLabel.text = formatter.string(from: tweet.created)

        let txt = tweet.text
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: txt, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 14.0)!])
        for mentionData in tweet.hashtags {
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: mentionData.nsrange)
        }
        
        for mentionData in tweet.urls {
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: mentionData.nsrange)
        }
        
        for mentionData in tweet.userMentions {
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: mentionData.nsrange)
        }
        cell.tweetTextLabel.numberOfLines = 0
        cell.tweetTextLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.tweetTextLabel.attributedText = myMutableString
        cell.tweetTextLabel.sizeToFit()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tweet = tweets[indexPath.section][indexPath.row]
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "mentionstvc") as! MentionsTVC
        vc.tweet = tweet
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
