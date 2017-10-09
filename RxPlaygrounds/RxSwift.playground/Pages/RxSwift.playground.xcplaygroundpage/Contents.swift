//: Playground - noun: a place where people can play

import UIKit
import RxSwift
import RxCocoa
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

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
