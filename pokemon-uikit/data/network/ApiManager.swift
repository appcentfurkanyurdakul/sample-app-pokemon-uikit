//
//  ApiManager.swift
//  pokemon-uikit
//
//  Created by Furkan Yurdakul on 24.06.2024.
//

import Foundation

class ApiManager {
    
    static let shared = ApiManager()
    
    private let baseUrl = "https://pokeapi.co/api/v2"
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private init(){
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    /// Performs a network request using the baseUrl and appending the ``endpoint``to it.
    /// To initiate a network call with a full URL, use ``makeRequest(url:method:requestModel:)`` instead.
    func makeRequest<X: Codable>(
        endpoint: String,
        method: RequestMethod,
        requestModel: Codable? = nil
    ) async -> ApiResult<X> {
        let fixedEndpoint = if endpoint.starts(with: "/") {
            endpoint
        } else {
            "/\(endpoint)"
        }
        return await makeRequest(
            url: self.baseUrl + fixedEndpoint,
            method: method,
            requestModel: requestModel
        )
    }
    
    /// Performs a network request using the given ``url``.
    func makeRequest<X: Codable>(
        url: String,
        method: RequestMethod,
        requestModel: Codable? = nil
    ) async -> ApiResult<X> {
        if !ConnectionManager.shared.hasInternet() {
            return .error(.noNetwork, "Please check your internet connection.")
        }
        var urlComponents = URLComponents(string: url)!
        if requestModel != nil && method == .GET {
            let body = try! encoder.encode(requestModel!)
            let map = try! JSONSerialization.jsonObject(with: body, options: []) as? [String: Any]
            let queryItems = map?.map({ (key: String, value: Any) in
                URLQueryItem(name: key, value: String(describing: value))
            })
            urlComponents.queryItems = queryItems
        }
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        if requestModel != nil {
            if method != .GET {
                let jsonBody = try! encoder.encode(requestModel!)
                request.httpBody = jsonBody
                request.setValue(
                    String(describing: jsonBody.count),
                    forHTTPHeaderField: "Content-Length"
                )
            }
        }
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                return .error(.invalidResponse, "Invalid response.")
            }
            if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
                do {
                    let parsedData: X = try decoder.decode(X.self, from: data)
                    return .success(parsedData)
                } catch {
                    return .error(.parseError, error.localizedDescription)
                }
            } else {
                return .error(.httpCode(httpResponse.statusCode), "\(httpResponse)")
            }
        } catch {
            return .error(.unknownError, error.localizedDescription)
        }
    }
}
