//: Playground - noun: a place where people can play

import UIKit
import RxSwift
import RxCocoa
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

/* Rx example1
let myFirstObservable = Observable<Int>.create{ observer in
    observer.on(.next(1))
    observer.on(.next(2))
    observer.on(.next(3))
    observer.on(.completed)
    return Disposables.create()
}

let subscription = myFirstObservable
    .map{ $0 * 5 }
    .subscribe(onNext: { print("map: \($0)")})

subscription.dispose()
*/

struct SearchResult {
    let repos:[GithubRepository]
    let totalCount: Int
    init?(response: Any) {
        guard let response = response as? [String:Any],
            let reposDictionaries = response["items"] as? [[String:Any]],
            let count = response["total_count"] as? Int
            else { return nil }

        repos = reposDictionaries.flatMap{ GithubRepository(dictionary: $0) }
        totalCount = count
    }
}

struct GithubRepository {
    let name: String
    let startCount: Int
    init(dictionary: [String:Any]) {
        name = dictionary["full_name"] as! String
        startCount = dictionary["stargazers_count"] as! Int
    }
}

func searchRepos(keyword: String) -> Observable<SearchResult?> {
    let endPoint = "http://api.github.com"
    let path = "/search/repositories"
    let query = "?q=¥\(keyword)"
    let url = URL(string: endPoint + path + query)!
    let request = URLRequest(url: url)
    
    return URLSession.shared
        .rx.json(request: request)
        .map{ SearchResult(response: $0)}
}

let subscription = searchRepos(keyword: "RxSwift")
    .subscribe(onNext: { print($0!) })
