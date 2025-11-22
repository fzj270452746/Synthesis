//
//  GridLatticeFabricator.swift
//  Synthesis - Infrastructure Factory
//
//  Factory for creating tessellation matrix grids.
//  Determines grid dimensions based on difficulty echelon.
//

import Foundation

class GridLatticeFabricator {

    // MARK: - Static Factory Methods

    /// Fabricates tessellation matrix for specified difficulty echelon
    static func fabricateLattice(forEchelon echelon: DifficultyEchelon) -> TessellationMatrix {
        let dimensionalCapacity = echelon.latticeDimensionalCapacity
        return TessellationMatrix(dimensionalCapacity: dimensionalCapacity)
    }

    /// Fabricates lattice with custom dimensions
    static func fabricateLattice(withDimensions dimensions: Int) -> TessellationMatrix {
        let clampedDimensions = max(3, min(dimensions, 10))
        return TessellationMatrix(dimensionalCapacity: clampedDimensions)
    }

    /// Fabricates lattice pre-populated with fragments
    static func fabricatePopulatedLattice(
        forEchelon echelon: DifficultyEchelon,
        populationDensity: Double = 0.3
    ) -> TessellationMatrix {
        let lattice = fabricateLattice(forEchelon: echelon)
        let forge = FragmentArchetypeForge(echelon: echelon)

        // Calculate population quantity
        let totalCapacity = lattice.totalCapacity
        let populationQuantity = Int(Double(totalCapacity) * populationDensity)

        // Get random vacant coordinates
        var vacantCoordinates = lattice.excavateVacantCoordinates()
        vacantCoordinates.shuffle()

        // Populate with fragments
        for index in 0..<min(populationQuantity, vacantCoordinates.count) {
            let coordinate = vacantCoordinates[index]
            let fragment = forge.forgeFragment()
            try? lattice.anchorFragment(fragment, at: coordinate)
        }

        return lattice
    }
}

// MARK: - Lattice Configuration Presets

extension GridLatticeFabricator {

    enum LatticePreset {
        case compact      // 3x3
        case standard     // 4x4
        case expansive    // 6x6
        case custom(Int)

        var dimensionalCapacity: Int {
            switch self {
            case .compact: return 3
            case .standard: return 4
            case .expansive: return 6
            case .custom(let size): return size
            }
        }
    }

    static func fabricateLattice(preset: LatticePreset) -> TessellationMatrix {
        return fabricateLattice(withDimensions: preset.dimensionalCapacity)
    }
}
