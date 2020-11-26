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
    
    private var pendingRequestWorkItem: DispatchWorkItem?
    var bind : (() -> ()) = {}
    var page = 1
    var isLastPage = false
    var keyword = ""
    public func searchFor(keyword:String) {
        page = 1
        self.keyword = keyword
        
        pendingRequestWorkItem?.cancel()
        
        let requestWorkItem = DispatchWorkItem { [weak self] in
            self?.getMoviesRequest()
        }
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500),
                                      execute: requestWorkItem)
        
    }
    
    public func loadMore(){
        guard !self.isLastPage else { return }
        page += 1
        getMoviesRequest()
    }
    
    
    private func getMoviesRequest(){
        APIManager.shared.getMovieList(self.keyword, page: self.page) { (result, errorMessage, data) in
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
