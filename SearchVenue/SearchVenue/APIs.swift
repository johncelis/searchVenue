//
//  APIs.swift
//  SearchVenue
//
//  Created by John Lester Celis on 11/01/2019.
//  Copyright © 2019 John Lester Celis. All rights reserved.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case parseError
    case requestError
}

enum Result<T> {
    case success(T)
    case error(Error)
}

struct Venue: Codable {
    let id: String
    let name: String
    let location: Location
}

struct Location: Codable {
    let distance: Int
    let formattedAddress: [String]
}

struct VenueResponses: Codable {
    let venues: [Venue]
}

struct FirstResponse: Codable {
    let response: VenueResponses
}

func getRequestMethod<T: Codable>(_ ll : String, completion: @escaping (Result<T>) -> Void) {
    let clientID = "DQPZWBGBBJTBAMQPXEBCLF4SCHDILP3QQ5LH42T4IEO0X0TL"
    let clientSECRET = "FIEFQFBGCD0WVDLDADGVLVPGZAFPHKILOWSOYS3P1WWQGFCN"
    let request = "https://api.foursquare.com/v2/venues/search?ll=\(ll)&client_id=\(clientID)&client_secret=\(clientSECRET)&v=20190110"
    guard let url = URL(string: request) else {return}
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else {
            completion(Result.error(APIError.requestError))
            return
        }
        do {
            let decoder = JSONDecoder()
            let results = try decoder.decode(T.self, from: data)
            completion(Result.success(results))
        } catch let err {
            completion(Result.error(err))
        }
        }.resume()
}
