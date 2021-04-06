//
//  SpotlightSearchModel.swift
//  SwiftUIExample
//
//  Created by Seoksoon Jang on 2019/12/04.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

#if os(iOS)

import Foundation
import Combine

struct SpotlightSearchModel {
    public var searchKeywords: [String]
    public var searchResultSubject = PassthroughSubject<[SearchResult], SpotlightError>()
}

// MARK: - Private Methods
extension SpotlightSearchModel {
    public func searchItems(forKeyword searchingText: String) -> Void {
        guard let url = URL(string:"http://google.com/complete/search?output=toolbar&q=\(searchingText.replacingOccurrences(of: " ", with: ""))")
            else {
                return
        }
        
        if self.searchKeywords.count >= 1 {
            let founds = self.searchKeywords
                .filter {
                    if searchingText == "" {
                        return false
                    } else {
                        return $0
                            .lowercased()
                            .contains(searchingText.lowercased())
                    }
            }

            searchResultSubject.send(founds)

        } else {
            AutoCompleteParser.parse(url: url) { suggestion, error in
                self.searchResultSubject.send(suggestion)
            }
        }
    }

}

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

#endif
