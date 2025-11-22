//
//  MahjongTileEntity.swift
//  Synthesis
//
//  Created by Hades on 11/18/25.
//

import Foundation

struct MahjongTileEntity: Equatable {
    let uniqueIdentifier: String
    let numericalValue: Int

    init(value: Int) {
        self.uniqueIdentifier = UUID().uuidString
        self.numericalValue = value
    }

    var assetImageName: String {
        return "\(numericalValue)\(numericalValue)"
    }

    static func == (lhs: MahjongTileEntity, rhs: MahjongTileEntity) -> Bool {
        return lhs.numericalValue == rhs.numericalValue
    }
}

struct GridPositionCoordinate: Hashable {
    let rowIndex: Int
    let columnIndex: Int
}
