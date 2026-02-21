import Foundation

enum IslandPhase: Equatable {
    case hidden
    case recording
    case processing
    case expanded(NvimInstruction)
    case collapsing(NvimInstruction)
}

@Observable
final class IslandState {
    var phase: IslandPhase = .hidden
}
