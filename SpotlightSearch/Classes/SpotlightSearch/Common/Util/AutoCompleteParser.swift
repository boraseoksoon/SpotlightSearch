//
//  AutoCompleteParser.swift
//  Pods-QuickExample
//
//  Created by Seoksoon Jang on 2021/04/07.
//

import Foundation
import Combine

enum AutoCompleteError: Error {
    case notFound
}

class AutoCompleteParser: NSObject {
    var suggestions: [String] = []

    class func parseToAnyPublisher(url: URL) -> AnyPublisher<[String], Error> {
        Future<[String], Error> { promise in
            AutoCompleteParser.parse(url: url) { suggestions, error in
                if error != nil {
                    promise(.failure(AutoCompleteError.notFound))
                    return
                }
                
                promise(.success(suggestions))
            }
        }.eraseToAnyPublisher()
    }
    
    class func parse(url: URL, completion: @escaping ([String], Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion([], error)
                return
            }

            let delegate = AutoCompleteParser()
            let parser = XMLParser(data: data)
            parser.delegate = delegate

            parser.parse()

            completion(delegate.suggestions, nil)
        }

        task.resume()
    }
}

extension AutoCompleteParser: XMLParserDelegate {
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        switch elementName {
            case "suggestion":
                if let suggestion = attributeDict["data"] {
                    suggestions.append(suggestion)
                }
                
            default:
                break
        }
    }
    
    func parser(_ parser: XMLParser,
                parseErrorOccurred parseError: Error) {
        suggestions = []
    }
}

