//
//  TweetTVCell.swift
//  TweeterTags
//
//

import UIKit

class TweetTVCell: UITableViewCell {
    @IBOutlet weak var tweetAvatarImageView : UIImageView!
    @IBOutlet weak var tweetScreenNameLabel : UILabel!
    @IBOutlet weak var tweetCreatedLabel : UILabel!
    @IBOutlet weak var tweetTextLabel : UILabel!
    
   // override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
   // }

    override func  awakeFromNib(){
        super.awakeFromNib()
    }
   // required init?(coder aDecoder: NSCoder) {
     //   fatalError("init(coder:) has not been implemented")
    //}
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
