//
//  CategoryBitMask.swift
//  list_up
//
//  Created by eyexpo on 2017-07-06.
//  Copyright © 2017 eyexpo. All rights reserved.
//

import SceneKit

public struct CategoryBitMask: OptionSet {
    public var rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension CategoryBitMask {
    public static let all = CategoryBitMask(rawValue: .max)
    public static let leftEye = CategoryBitMask(rawValue: 1 << 21)
    public static let rightEye = CategoryBitMask(rawValue: 1 << 22)
}
