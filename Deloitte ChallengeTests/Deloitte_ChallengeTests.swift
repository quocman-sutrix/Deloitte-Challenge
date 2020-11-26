//
//  Deloitte_ChallengeTests.swift
//  Deloitte ChallengeTests
//
//  Created by Lu Quoc Man on 11/24/20.
//  Copyright © 2020 Lu Quoc Man. All rights reserved.
//

import XCTest
@testable import Mocker

class Deloitte_ChallengeTests: XCTestCase {

    func testSearchMovieWithKeyWordHaveDataReturned() {
        let originalURL = URL(string: "http://www.omdbapi.com/?apikey=b9bd48a6&s=Marvel&type=movie")!
        
        Mock(url: originalURL, dataType: .json, statusCode: 200, data: [
            .get: MockedData.MovieListResponse.data
            ]
        ).register()
        
        let movieListViewModel =  MovieListViewModel()
        movieListViewModel.searchFor(keyword:"marvel")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssert(movieListViewModel.movieList?.count ?? 0 > 0)
        }
        
        
    }
    
    func testSearchMovieWithKeyWordWithoutDataReturned() {
        let originalURL = URL(string: "http://www.omdbapi.com/?apikey=b9bd48a6&s=Delll&type=movie")!
        
        Mock(url: originalURL, dataType: .json, statusCode: 200, data: [
            .get: MockedData.MovieListNoDataResponse.data
            ]
        ).register()
        
        let movieDetailViewModel = MovieDetailViewModel()
        movieDetailViewModel.getDetails(imdbID: "b9bd48a6")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssert(movieDetailViewModel.movieDetail == nil)
        }
        
    }
    
    func testGetMovieWithIdHaveDataReturned() {
        let originalURL = URL(string: "http://www.omdbapi.com/?apikey=b9bd48a6&i=tt4154664")!
        
        Mock(url: originalURL, dataType: .json, statusCode: 200, data: [
            .get: MockedData.MovieDetailResponse.data
            ]
        ).register()
        
        let movieListViewModel =  MovieListViewModel()
        movieListViewModel.searchFor(keyword:"marvel")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssert(movieListViewModel.movieList?.count ?? 0 > 0)
        }
    }
    
    func testGetMovieWithIdWithoutDataReturned() {
         let originalURL = URL(string: "http://www.omdbapi.com/?apikey=b9bd48a6&i=tt415466433")!
         
         Mock(url: originalURL, dataType: .json, statusCode: 200, data: [
             .get: MockedData.MovieDetailNoDataResponse.data
             ]
         ).register()
         
         let movieListViewModel =  MovieListViewModel()
         movieListViewModel.searchFor(keyword:"marvel")
        
         DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
             XCTAssert(movieListViewModel.movieList?.count ?? 0 > 0)
         }
    }

}
