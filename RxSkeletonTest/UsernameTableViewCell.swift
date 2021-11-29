//
//  UsernameTableViewCell.swift
//  RxSkeletonTest
//
//  Created by Inpyo Hong on 2021/11/29.
//

import UIKit
import SkeletonView

class UsernameTableViewCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.isSkeletonable = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func configure(tableView: UITableView, indexPath: IndexPath, username: String) -> UITableViewCell {
        print(#function, username)
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsernameTableViewCell", for: indexPath) as! UsernameTableViewCell
        cell.usernameLabel.text = username
        cell.imgView.layer.cornerRadius = cell.imgView.bounds.width/2
        return cell
    }
}
