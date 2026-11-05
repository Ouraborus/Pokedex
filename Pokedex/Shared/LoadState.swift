//
//  LoadState.swift
//  Pokedex
//
//  Created by Ouraborus on 5/11/26.
//

import Foundation

enum LoadState<Value: Equatable>:Equatable {
    case idle
    case loading
    case loaded(Value)
    case empty
    case failed(String)
}
