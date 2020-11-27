//
//  Networker.swift
//  KanyeWithMe
//
//  Created by Nicholas Bittencourt  on 2020-11-27.
//

import Foundation

enum NetworkerError: Error {
  case badResponse
  case badStatusCode(Int)
  case badData
}

class Networker {
    
    static let shared = Networker()
      
    private let session: URLSession
      
    init() {
    
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    func getQuote(completion: @escaping (KanyeQuote?, Error?) -> (Void)) {
        
      let url = URL(string: "https://api.kanye.rest/")!
      
      var request = URLRequest(url: url)
      request.httpMethod = "GET"
      
      let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
        
        if let error = error {
            completion(nil, error)
          return
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(nil, NetworkerError.badResponse)
          return
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            completion(nil, NetworkerError.badStatusCode(httpResponse.statusCode))
          return
        }
        
        guard let data = data else {
            completion(nil, NetworkerError.badData)
          return
        }
        
        do {
          let kanye = try JSONDecoder().decode(KanyeQuote.self, from: data)
            completion(kanye, nil)
        } catch let error {
            completion(nil, error)
        }
      }
      task.resume()
    }
}
