//
//  MovieListViewModel.swift
//  Deloitte Challenge
//
//  Created by Lu Quoc Man on 11/23/20.
//  Copyright © 2020 Lu Quoc Man. All rights reserved.
//

import Foundation

class MovieListViewModel : NSObject {
    var movieList: [MovieListItemData]? {
        didSet {
            self.bind()
        }
    }
    var bind : (() -> ()) = {}
    var page = 1
    var isLoading = false
    var isLastPage = false
    var keyword = ""
    public func searchFor(keyword:String) {
        
        //Only call when the keyword length have at least 5 characters to prevent spamming the API
        if keyword.count > 4 {
            page = 1
            self.keyword = keyword
            getMovies()
        }
    }
    
    public func loadMore(){
        guard !self.isLoading, !self.isLastPage else { return }
        page += 1
        getMovies()
    }
    
    private func getMovies(){
        self.isLoading = true
        APIManager.shared.getMovieList(self.keyword, page: self.page) { (result, errorMessage, data) in
            self.isLoading = false
            if result {
                if self.page == 1 {
                    self.movieList = data?.Search
                }else{
                    if let movieListItemDatas = data?.Search {
                        var updatedMovieList = self.movieList
                        updatedMovieList?.append(contentsOf: movieListItemDatas)
                        self.isLastPage = updatedMovieList!.count >= data!.total
                        self.movieList = updatedMovieList
                    }
                }
            }else{
                print(errorMessage)
            }
        }
    }
}
