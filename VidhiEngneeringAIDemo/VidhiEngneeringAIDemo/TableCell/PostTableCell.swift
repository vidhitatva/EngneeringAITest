//
//  PostTableCell.swift
//  VidhiEngneeringAIDemo
//
//  Created by MAC105 on 20/01/20.
//  Copyright © 2020 MAC105. All rights reserved.
//

import UIKit

class PostTableCell: UITableViewCell {
    @IBOutlet weak var labelPostTitle: UILabel!
    @IBOutlet weak var labelPostDate: UILabel!
    @IBOutlet weak var switchPostActiveDeactive: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var postHint : Hits? {
        didSet {
            if let hint = self.postHint {
                if let title = hint.title {
                    self.labelPostTitle.text = title
                }
                if let createDate = hint.created_at {
                    let formate = DateFormatter()
                    formate.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'"
                    formate.timeZone = TimeZone.current
                    if let createdt = formate.date(from: createDate) {
                        let displayformate = DateFormatter()
                        displayformate.dateFormat = "E, d MMM yyyy hh:mm:ss a"
                        self.labelPostDate.text = displayformate.string(from: createdt)
                    }
                }
                self.switchPostActiveDeactive.isOn = hint.isActive
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
