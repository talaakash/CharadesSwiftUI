//
//  ApiManager.swift
//  CharadesSwiftUI
//
//  Created by Akash Tala on 03/05/25.
//

import Foundation

enum RequestType: String {
    case get = "GET"
    case post = "POST"
}

typealias ErrorCallBack = (String) -> Void

class ApiManager {
    static let shared = ApiManager()
    private init() { }
    
    func makeApiCall(url: String, method: RequestType, headers: [String: String]? = nil, body: [String: Any]? = nil, success: @escaping (Any) -> Void, failure: @escaping ErrorCallBack){
        guard let apiUrl = URL(string: url) else { return }
        var request = URLRequest(url: apiUrl)
        request.httpMethod = method.rawValue
        if let headers {
            request.allHTTPHeaderFields = headers
            debugPrint("Header: \(headers)")
        }
        if let body {
            debugPrint("Request: \(body)")
            let data = try? JSONSerialization.data(withJSONObject: body)
            request.httpBody = data
        }
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let data {
                let json = try? JSONSerialization.jsonObject(with: data)
                if let json {
                    success(json)
                    debugPrint("Response Json: \(json)")
                } else {
                    failure("unknownError".localize())
                }
            } else {
                failure(error?.localizedDescription ?? "unknownError".localize())
            }
        }).resume()
    }
}
