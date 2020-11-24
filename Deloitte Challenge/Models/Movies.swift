//
//  Movies.swift
//  Deloitte Challenge
//
//  Created by Lu Quoc Man on 11/23/20.
//  Copyright © 2020 Lu Quoc Man. All rights reserved.
//

import Foundation

//This model will be used to map the response from API
struct GetMovieListResponse: Decodable {
    var totalResults: String?
    var Response: String?
    var Search: [MovieListItemData]?
    
    var total: Int {
        get {
            return Int(self.totalResults ?? "0") ?? 0
        }
    }
}

struct MovieListItemData: Codable {
    var Title: String?
    var Year: String?
    var imdbID: String?
    var `Type`: String?
    var Poster: String?
}


struct MovieDetailResponse: Codable {
    var Title: String?
    var Year: String?
    var Rated: String?
    var Released: String?
    var Runtime: String?
    var Genre: String?
    var Director: String?
    var Writer: String?
    var Actors: String?
    var Plot: String?
    var Language: String?
    var Country: String?
    var Awards: String?
    var Poster: String?
    var Metascore: String?
    var imdbRating: String?
    var imdbVotes: String?
    var imdbID: String?
    var `Type`: String?
    var Ratings:[MovieDetailRatingItem]?
    var DVD: String?
    var BoxOffice: String?
    var Production: String?
    var Website: String?
    var Response: String?
}
struct MovieDetailRatingItem: Codable {
    var Source: String?
    var Value: String?
}
