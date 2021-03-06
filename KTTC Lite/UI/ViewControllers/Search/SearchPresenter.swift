//
//  SearchPresenter.swift
//  KTTC Lite
//
//  Created by Ярослав Стрельников on 26.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import Foundation

final class SearchPresenter {

    // MARK: - Private properties -

    private unowned let view: SearchViewInterface
    let formatter: SearchFormatterInterface
    private let interactor: SearchInteractorInterface
    private let wireframe: SearchWireframeInterface

    // MARK: - Lifecycle -

    init(view: SearchViewInterface, formatter: SearchFormatterInterface, interactor: SearchInteractorInterface, wireframe: SearchWireframeInterface) {
        self.view = view
        self.formatter = formatter
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension SearchPresenter: SearchPresenterInterface {
    func didSearchUsers(by keyword: String, with gameType: KTTCApi.GameType, completed: @escaping (() -> Void)) {
        interactor.searchUser(bySearchKeyword: keyword, withGameType: gameType, completed: completed)
    }
    
    func didFinish() {
        view.reloadData()
    }
}
