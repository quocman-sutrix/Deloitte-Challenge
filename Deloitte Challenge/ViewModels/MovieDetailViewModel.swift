//
//  MovieDetailViewModel.swift
//  Deloitte Challenge
//
//  Created by Lu Quoc Man on 11/23/20.
//  Copyright © 2020 Lu Quoc Man. All rights reserved.
//

import Foundation

class MovieDetailViewModel : NSObject {
    
    var movieDetail: MovieDetailResponse? {
        didSet {
            self.bind()
        }
    }
    var bind : (() -> ()) = {}
    
    public func getDetails(imdbID:String) {
        
        APIManager.shared.getMovieDetail(imdbID) { (result, errorMessage, data) in
            if result {
                self.movieDetail = data
            }else{
                print(errorMessage)
            }
        }
    }
    
}
