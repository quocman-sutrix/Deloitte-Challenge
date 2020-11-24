//
//  MovieDetailViewController.swift
//  Deloitte Challenge
//
//  Created by Lu Quoc Man on 11/23/20.
//  Copyright © 2020 Lu Quoc Man. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    //MARK: - IBOutlet declerations
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var imdbScoreLabel: UILabel!
    @IBOutlet weak var imdbVotesLabel: UILabel!
    @IBOutlet weak var metaScoreLabel: UILabel!
    @IBOutlet weak var trailerButton: UIButton!
    
    //MARK: - Private declerations
    private let movieDetailViewModel = MovieDetailViewModel()
    
    //MARK: - Set from parent view
    var movieItemData: MovieListItemData?
    var blurViewAdded: Bool = false
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addBlurEffect()
        configurateForUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getMovieDetail()
        configurateForUI()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    //MARK: - Other methods
    func configurateForUI() {
        movieDetailViewModel.bind = {
            self.updateMovieDetail()
        }
        
        if  let movieItemData   = self.movieItemData,
            let title           = movieItemData.Title,
            let poster          = movieItemData.Poster
        {
            self.setBackground(url: poster)
            self.setPoster(url: poster)
            
            titleLabel.text = title
        }
        posterImageView.dropShadow(
            color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            opacity: 0.6,
            offSet: CGSize(width: 0, height: 0),
            radius: 30,
            scale: false,
            cornerRadius:30
        )
        
    }
    
    func updateMovieDetail() {
        if  let movieDetail     = self.movieDetailViewModel.movieDetail,
            let genre           = movieDetail.Genre,
            let imdbScore       = movieDetail.imdbRating,
            let imdbVotes       = movieDetail.imdbVotes,
            let metaScore       = movieDetail.Metascore
        {
            self.genreLabel.text        = genre
            self.imdbScoreLabel.text    = imdbScore
            self.imdbVotesLabel.text    = imdbVotes
            self.metaScoreLabel.text    = metaScore
            
            let excludeKeys = ["Title", "Poster", "Rated", "imdbVotes", "Metascore", "imdbRating", "Type", "Genre", "Response", "imdbID", "Ratings"]
            do {
                let movieDetailDictionary = try movieDetail.asDictionary()
                let otherInformation = movieDetailDictionary.keys.sorted().reduce(
                    NSMutableAttributedString(),
                    { (result, key) -> NSMutableAttributedString in
                        
                        if excludeKeys.contains(key) {
                            return result
                        }else{
                            return appendMovieData(
                                originalString: result,
                                title: key, subtitle:
                                movieDetailDictionary[key] as! String
                            )
                        }
                })
                self.plotLabel.attributedText = otherInformation
                
            }catch{
                print("Can't convert movieDetailDictionary to dictionary")
            }
            
        }
    }
    func addBlurEffect() {
        if !blurViewAdded {
            blurViewAdded = true
            let blurEffect = UIBlurEffect(style: .dark)
            let blurredEffectView = UIVisualEffectView(effect: blurEffect)
            blurredEffectView.frame = backgroundView.bounds
            backgroundView.addSubview(blurredEffectView)
        }
    }
    func appendMovieData(
        originalString: NSMutableAttributedString,
        title: String,
        subtitle: String) -> NSMutableAttributedString
    {
        
        let updatedString: NSMutableAttributedString = originalString
        let titleAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.orange
        ]
        let subtitleAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        
        let _title = NSAttributedString(string: "\(title)\n", attributes: titleAttributes)
        let _subtitle = NSAttributedString(string: "\(subtitle)\n\n", attributes: subtitleAttributes)
        
        updatedString.append(_title)
        updatedString.append(_subtitle)
        
        return updatedString
    }
    
    func getMovieDetail() {
        if  let movieItemData   = self.movieItemData,
            let imdbID          = movieItemData.imdbID
        {
            movieDetailViewModel.getDetails(imdbID: imdbID)
        }
    }
    func setPoster(url:String){
        
        if url.contains("http") {
            posterImageView.load(withUrl: url)
        }else{
            posterImageView.image = #imageLiteral(resourceName: "no_photo")
        }
        
    }
    func setBackground(url:String){
        if url.contains("http") {
            backgroundImageView.load(withUrl: url)
        }else{
            backgroundImageView.image = #imageLiteral(resourceName: "no_photo")
        }
    }
    
    //MARK: - IBActions
    @IBAction func trailerButtonTapped(_ sender: UIButton) {
        
        if  let title = self.movieDetailViewModel.movieDetail?.Title?.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed),
            let url = URL(string: "https://www.youtube.com/results?search_query='\(title)'")
        {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
