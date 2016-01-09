//
//  ConfigurableCell.swift
//  TaskBerserk
//
//  Created by Александр on 09.01.16.
//  Copyright © 2016 Alexander Guschin. All rights reserved.
//

import Foundation

protocol ConfigurableCell {
    typealias DataSource
    func configureForObject(object: DataSource)
}