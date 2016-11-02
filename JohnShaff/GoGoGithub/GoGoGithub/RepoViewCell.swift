//
//  RepoViewCell.swift
//  GoGoGithub
//
//  Created by John Shaff on 11/2/16.
//  Copyright © 2016 John Shaff. All rights reserved.
//

import UIKit

class RepoViewCell: UITableViewCell {
    
    @IBOutlet weak var repoName: UILabel!
    
    @IBOutlet weak var repoLanguage: UILabel!
    
    @IBOutlet weak var repoDescription: UILabel!
    
    var repo: Repository! {
        didSet {
            self.repoName.text = repo.name
            if repo.language != nil {
                self.repoLanguage?.text = repo.language
            }
            if repo.description != nil {
                self.repoDescription?.text = repo.description
            }
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
