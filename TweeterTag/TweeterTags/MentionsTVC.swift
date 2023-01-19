//
//  MentionsTVC.swift
//  TweeterTags
//
//

import Foundation
import UIKit

class MentionsTVC: UITableViewController {
    var tweet : TwitterTweet?
    var sectionheaders = ["Images","URLs","Hashtags","Users"]
    var media: [TwitterMedia] = [TwitterMedia]()
    var hashtags: [TwitterMention] = [TwitterMention]()
    var urls: [TwitterMention] = [TwitterMention]()
    var userMentions: [TwitterMention] = [TwitterMention]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = tweet?.user.screenName
        media = tweet!.media
        hashtags = tweet!.hashtags
        urls = tweet!.urls
        userMentions = tweet!.userMentions
    }
    
    // MARK: - Table view data source
    //Number of table partitions
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    //Number of cells under partition
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return media.count
        }
        else if section == 1 {
            return urls.count
        }
        else if section == 2 {
            return hashtags.count
        }
        else if section == 3 {
            return userMentions.count
        }
        return 0
    }
    
    //Return to Custom Cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "cellID"
         
        var cell = tableView.dequeueReusableCell(withIdentifier: cellid)
        if cell==nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellid)
        }
        if indexPath.section == 0 {
            let url = self.media[indexPath.row].url
            let imgdata = try! Data(contentsOf: url)
            let newImage = UIImage(data: imgdata)
            let imgView = UIImageView()
            imgView.frame = cell!.bounds
            imgView.image = newImage
            imgView.contentMode = .scaleAspectFill
            cell?.addSubview(imgView)
        } else if indexPath.section == 1 {
            cell?.textLabel?.text = self.urls[indexPath.row].keyword
        } else if indexPath.section == 2 {
            cell?.textLabel?.text = self.hashtags[indexPath.row].keyword
        } else if indexPath.section == 3 {
            cell?.textLabel?.text = self.userMentions[indexPath.row].keyword
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 && self.media.count == 0 {
            return ""
        }
        if section == 1 && self.urls.count == 0 {
            return ""
        }
        if section == 2 && self.hashtags.count == 0 {
            return ""
        }
        if section == 3 && self.userMentions.count == 0 {
            return ""
        }
        return self.sectionheaders[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        }else {
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "imagevc") as! ImageVC
            vc.imgurl = self.media[indexPath.row].url.absoluteString
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.section == 1 {
            if let url = URL(string: self.urls[indexPath.row].keyword) {
                //Handle separately according to iOS system version
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: {(success) in})
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        else {
            let txt = self.hashtags[indexPath.row].keyword
            let sb = UIStoryboard(name: "Main", bundle:nil)
            let vc = sb.instantiateViewController(withIdentifier: "tweetstvc") as! TweetsTVC
            vc.twitterQueryText = txt
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}
