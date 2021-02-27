//
//  WorkoutCell.swift
//  UsHealth
//
//  Created by Derek Nguyen on 2/27/21.
//

import UIKit

class WorkoutCell: UITableViewCell {

    
    @IBOutlet weak var checkMarkImage: UIImageView!
    @IBOutlet weak var workoutLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
