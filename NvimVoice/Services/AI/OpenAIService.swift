import Foundation

actor OpenAIService {
    private let session = URLSession.shared
    private let endpoint = URL(string: "https://api.openai.com/v1/chat/completions")!

    func analyzeScreenWithVoice(
        base64Image: String,
        prompt: String,
        detail: String = "low"
    ) async throws -> NvimInstruction {
        guard let apiKey = KeychainHelper.loadAPIKey(), !apiKey.isEmpty else {
            throw OpenAIError.missingAPIKey
        }

        let request = OpenAIChatRequest(
            model: "gpt-4o",
            messages: [
                OpenAIMessage(role: "user", content: [
                    .text(prompt),
                    .imageURL(
                        url: "data:image/jpeg;base64,\(base64Image)",
                        detail: detail
                    ),
                ]),
            ],
            maxTokens: 500,
            temperature: 0.3
        )

        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.timeoutInterval = 30

        let encoder = JSONEncoder()
        urlRequest.httpBody = try encoder.encode(request)

        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw OpenAIError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            if let errorResponse = try? JSONDecoder().decode(OpenAIErrorResponse.self, from: data) {
                throw OpenAIError.apiError(errorResponse.error.message)
            }
            throw OpenAIError.httpError(httpResponse.statusCode)
        }

        let chatResponse = try JSONDecoder().decode(OpenAIChatResponse.self, from: data)

        guard let content = chatResponse.choices.first?.message.content else {
            throw OpenAIError.emptyResponse
        }

        return try parseInstruction(from: content)
    }

    private func parseInstruction(from content: String) throws -> NvimInstruction {
        // Extract JSON from the response (may be wrapped in markdown code block)
        var jsonString = content.trimmingCharacters(in: .whitespacesAndNewlines)

        if jsonString.hasPrefix("```json") {
            jsonString = String(jsonString.dropFirst(7))
        } else if jsonString.hasPrefix("```") {
            jsonString = String(jsonString.dropFirst(3))
        }
        if jsonString.hasSuffix("```") {
            jsonString = String(jsonString.dropLast(3))
        }
        jsonString = jsonString.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let data = jsonString.data(using: .utf8) else {
            throw OpenAIError.parseError
        }

        return try JSONDecoder().decode(NvimInstruction.self, from: data)
    }
}

enum OpenAIError: LocalizedError {
    case missingAPIKey
    case invalidResponse
    case httpError(Int)
    case apiError(String)
    case emptyResponse
    case parseError

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "OpenAI API key not set. Go to Settings to add it."
        case .invalidResponse:
            return "Invalid response from OpenAI"
        case .httpError(let code):
            return "OpenAI API error (HTTP \(code))"
        case .apiError(let message):
            return "OpenAI: \(message)"
        case .emptyResponse:
            return "Empty response from OpenAI"
        case .parseError:
            return "Failed to parse AI response"
        }
    }
}
