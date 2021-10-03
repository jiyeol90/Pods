//
//  VoiceChatRoomTableViewCell.swift
//  PlaySound
//
//  Created by james on 2021/09/02.
//

import UIKit

class VoiceChatRoomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var roomTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        if selected {
            contentView.layer.borderWidth = 2
            contentView.layer.borderColor = UIColor.blue.cgColor
        } else {
            contentView.layer.borderWidth = 1
            contentView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.layer.cornerRadius = 10
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
    }
    
}
