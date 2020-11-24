//
//  NetworkRequest.swift
//  Deloitte Challenge
//
//  Created by Lu Quoc Man on 11/23/20.
//  Copyright © 2020 Lu Quoc Man. All rights reserved.
//

import Foundation
import Alamofire

public typealias Parameters = [String: Any]
public typealias PathParameters = [String: String]

struct Network {
    static var Manager: Alamofire.Session = {
        let manager = ServerTrustManager(evaluators: ["www.omdbapi.com": DisabledTrustEvaluator()])
        let session = Session(serverTrustManager: manager)
        return session
    }()
    let messages = Messages()
    func request(to path: APIEndpoint, method: Alamofire.HTTPMethod, headers: HTTPHeaders, pathParams: PathParameters, queryParams: Parameters, body: Parameters, completion: @escaping (_ networkStatus: Bool, _ responseStatus: Bool, _ responseCode:Int, _ data: Data?) -> ()){
        
        guard Reachability().isConnected() else {
            
            print(Messages().networkUnreachable)
            return completion(false, false, 0, nil)
        }
        // Validation
        guard let url = URL(string: getBaseUrl(to: .Primary)) else {
            print(messages.urlInvalid)
            return
        }
        
        // Prepare Full Path
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            print(messages.urlNotResolved)
            return
        }
        urlComponents.path.append(bindPathParamsAndGeneratePath(from: pathParams, path: path))
        
        // Prepare Query URL
        urlComponents.queryItems = generateQueryParams(queryParams)
        urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        
        guard let completeURL = urlComponents.url else {
            print(messages.urlPreparationfailed)
            return
        }
        var bodyParams:Dictionary? = body
        if method == .get {
            bodyParams = nil
        }
        Network.Manager.request(completeURL.absoluteString, method: method, parameters: bodyParams , encoding: JSONEncoding.default, headers: headers, interceptor: nil, requestModifier: nil).response {  response in
            // Log
            /*print("--------------- --------------- -------------------------")
            print("Request URL: \(String(describing: completeURL.absoluteString))")
            print("Request Method: \(String(describing: method))")
            print("Request Body: \(String(describing: bodyParams))")
            print("Response code: \(response.response?.statusCode ?? -1)", "\n")
            print("Response header: \(headers)", "\n")
            print("Response: \(String(data: response.data ?? Data() , encoding: String.Encoding.utf8) ?? "")", "\n")
            print("--------------- --------------- -------------------------")*/
            
            
            var reponseCode = -1
            if let _response = response.response, _response.statusCode == 200 {
                reponseCode = _response.statusCode
            } else {
                completion(false, false, reponseCode, nil)
            }
            // Notify parent with response data
            completion(true, true, reponseCode, response.data)
        }
    }
    
    func getBaseUrl(to domain: APIEndpoint.Domain.Name) -> String {
        
        switch domain {
            
        case .Primary:
            return APIEndpoint.Domain.baseUrl
        }
        
    }
    
    func bindPathParamsAndGeneratePath(from params: PathParameters, path: APIEndpoint) -> String {
        
        if params.count > 0 {
            
            var path = path.string
            for (key, value) in params {
                
                path = path.replacingOccurrences(of: "{\(key)}", with: value)
            }
            return path
        } else {
            
            return path.string
        }
    }
    fileprivate func generateQueryParams(_ params: Parameters) -> [URLQueryItem]? {
        
        // Preapre Query URL
        if params.count >= 0 {
            
            var queryItems: [URLQueryItem] = []
            params.forEach { (key, value) in
                queryItems.append(URLQueryItem(name: key, value: "\(value)"))
            }
            if queryItems.count > 0 {
                return queryItems
            }
            else {
                return nil
            }
            
        }
        return nil
    }
}

public enum HTTPMethod: String {
    
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    
    var name: String {
        return self.rawValue
    }
}


public enum HTTPEncoding {
    
    case queryUrl, json
}



func generateRequestBody(from params: Parameters) -> Data {
    
    // Preapre Query URL
    var body = Data()
    if params.count > 0 {
        
        do {
            
            body = try JSONSerialization.data(withJSONObject: params, options: [])
            return body
        } catch {
            
            //if logActivity { print(Messages().requestBodyGenerationFailed) }
            return body
        }
    }
    return body
}



func generateRequestBody<T: Codable>(from params: T) -> Data {
    
    // Preapre Query URL
    var body = Data()
    do {
        
        body = try JSONEncoder().encode(params)
        return body
    } catch {
        
        //if logActivity { print(Messages().requestBodyGenerationFailed) }
        return body
    }
}

