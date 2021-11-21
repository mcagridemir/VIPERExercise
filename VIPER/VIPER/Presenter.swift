//
//  Presenter.swift
//  VIPER
//
//  Created by Macbook on 18.04.2021.
//

import Foundation

// Object
// protocol
// ref to interactor, router, view
// most cohesive glue in this architectural pattern

enum FetchError: Error {
    case failedGetUsers
}

protocol AnyPresenter {
    var router: AnyRouter? { get set }
    var interactor: AnyInteractor? { get set }
    var view: AnyView? { get set }
    
    func interactorDidFetchUsers(with result: Result<[User], Error>)
}

class UserPresenter: AnyPresenter {
    
    var router: AnyRouter?
    var interactor: AnyInteractor? {
        didSet {
            interactor?.getUsers()
        }
    }
    var view: AnyView?
    
    func interactorDidFetchUsers(with result: Result<[User], Error>) {
        switch result {
        case .success(let users):
            view?.update(with: users)
        case .failure(let error):
            view?.update(with: error.localizedDescription)
        }
    }
}
