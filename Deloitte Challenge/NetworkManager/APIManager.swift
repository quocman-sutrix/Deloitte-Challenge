//
//  APIManager.swift
//  Deloitte Challenge
//
//  Created by Lu Quoc Man on 11/23/20.
//  Copyright © 2020 Lu Quoc Man. All rights reserved.
//

import Foundation
import Alamofire

class APIManager: NSObject {
    
    // Declarations
    static let shared = APIManager()
    let network = Network()
    let messages = Messages()
    
}
extension APIManager {
    func getMovieList(_ keyword: String, page:Int = 1, completion: @escaping (_ responseCode: Bool, _ error: String, _ data: GetMovieListResponse? ) -> ()) {
        // Failure closure
        func failure(_ message: String) {
            completion(false, message, nil)
        }
        
        var queryParams = Parameters()
        queryParams["apikey"] = "b9bd48a6"
        queryParams["s"] = keyword
        queryParams["page"] = page
        queryParams["type"] = "movie"
        
        // Send Request
        network.request(to: APIEndpoint.root, method: .get, headers: HTTPHeaders(), pathParams: PathParameters(), queryParams: queryParams, body:Parameters()) { (networkStatus, responseStatus, responseCode, data) in
            
            // Network Error
            if !networkStatus {
                
                failure(self.messages.networkUnreachable)
                return
            }
            
            // Success Parse to Model
            if let response: GetMovieListResponse = Parser.parse(data) {
                
                let status = response.Response == "True"
                if status {
                    completion(status, "", response)
                } else {
                    failure("No result")
                }
                return
            }
            
            failure(self.messages.serverNotResponding)
        }
    }
    
    func getMovieDetail(_ imdbID: String, completion: @escaping (_ responseCode: Bool, _ error: String, _ data: MovieDetailResponse?) -> ()) {
        // Failure closure
        func failure(_ message: String) {
            completion(false, message, nil)
        }
        
        var queryParams = Parameters()
        queryParams["apikey"] = "b9bd48a6"
        queryParams["i"] = imdbID
        
        network.request(to: APIEndpoint.root, method: .post, headers: HTTPHeaders(), pathParams: PathParameters(), queryParams: queryParams, body: Parameters()) { (networkStatus, responseStatus, responseCode, data)
            in
            // Network Error
            if !networkStatus {
                failure(self.messages.networkUnreachable)
                return
            }
            // Success Parse to Model
            if let response: MovieDetailResponse = Parser.parse(data) {
                
                let status = response.Response == "True"
                if status {
                    completion(status, "", response)
                } else {
                    failure("Something went wrong!")
                }
                return
            }
            failure(self.messages.serverNotResponding)
        }
    }
}
struct GenericResponse: Decodable {
    
    var status: Bool?
    var statusMessage: String?
}
