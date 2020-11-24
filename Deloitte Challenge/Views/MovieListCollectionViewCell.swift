//
//  MovieListCollectionViewCell.swift
//  Deloitte Challenge
//
//  Created by Lu Quoc Man on 11/23/20.
//  Copyright © 2020 Lu Quoc Man. All rights reserved.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlet declerations
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    func setTitle(_ title: String){
        titleLabel.text = title
    }
    func setPoster (url: String){
        titleView.isHidden = true
        posterImageView.load(withUrl: url)
    }
    func setBlank (){
        titleView.isHidden = false
        posterImageView.image = #imageLiteral(resourceName: "no_photo")
    }
}
