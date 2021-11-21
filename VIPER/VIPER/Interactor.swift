//
//  Interactor.swift
//  VIPER
//
//  Created by Macbook on 18.04.2021.
//

import Foundation

// object
// protocol
// ref to presenter

// api calls etc.
// once interactor comes with data, calls the presenter and it tells the view to update
// view can also be a vc but ...

protocol AnyInteractor {
    var presenter: AnyPresenter? { get set }
    
    func getUsers()
}

class UserInteractor: AnyInteractor {
    var presenter: AnyPresenter?
    
    func getUsers() {
        print("start fetching")
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            guard let `self` = self else { return }
            guard let data = data, error == nil else {
                self.presenter?.interactorDidFetchUsers(with: .failure(FetchError.failedGetUsers))
                return
            }
            
            do {
                let entities = try JSONDecoder().decode([User].self, from: data)
                self.presenter?.interactorDidFetchUsers(with: .success(entities))
            } catch {
                self.presenter?.interactorDidFetchUsers(with: .failure(error))
            }
        }
        task.resume()
    }
}
