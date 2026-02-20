import Foundation

struct NvimInstruction: Codable, Equatable {
    let explanation: String
    let keySequence: String
    let steps: [String]
    let alternativeKeys: [String]?
    let physicalKeys: String?  // e.g., "Space (left thumb) -> F (left index) -> F"
}
