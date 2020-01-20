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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
