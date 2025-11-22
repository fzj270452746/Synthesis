//
//  CeramicGlyphFragment.swift
//  Synthesis
//
//  Created by Hades on 11/18/25.
//

import Foundation

struct CeramicGlyphFragment: Equatable {
    let quintessentialToken: String
    let hierarchicalMagnitude: Int

    init(magnitude: Int) {
        self.quintessentialToken = UUID().uuidString
        self.hierarchicalMagnitude = magnitude
    }

    var emblematicAssetDesignation: String {
        return "\(hierarchicalMagnitude)\(hierarchicalMagnitude)"
    }

    static func == (lhs: CeramicGlyphFragment, rhs: CeramicGlyphFragment) -> Bool {
        return lhs.hierarchicalMagnitude == rhs.hierarchicalMagnitude
    }
}

struct LatticeAnchorVector: Hashable {
    let horizontalStratum: Int
    let verticalOrdinate: Int
}
