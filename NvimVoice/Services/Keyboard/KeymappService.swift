import Foundation
import SQLite3

final class KeymappService {
    private static let dbPath = NSString(
        string: "~/Library/Containers/io.zsa.keymapp/Data/Library/Application Support/.keymapp/keymapp.sqlite3"
    ).expandingTildeInPath

    func loadLayout() -> KeyboardLayout? {
        guard FileManager.default.fileExists(atPath: Self.dbPath) else {
            Log.info("Keymapp database not found at \(Self.dbPath)")
            return nil
        }

        var db: OpaquePointer?
        guard sqlite3_open_v2(Self.dbPath, &db, SQLITE_OPEN_READONLY, nil) == SQLITE_OK else {
            Log.info("Failed to open Keymapp database")
            return nil
        }
        defer { sqlite3_close(db) }

        var stmt: OpaquePointer?
        let query = "SELECT data FROM revision ORDER BY rowid DESC LIMIT 1"
        guard sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK else {
            Log.info("Failed to prepare Keymapp query")
            return nil
        }
        defer { sqlite3_finalize(stmt) }

        guard sqlite3_step(stmt) == SQLITE_ROW else {
            Log.info("No rows in Keymapp revision table")
            return nil
        }

        guard let blob = sqlite3_column_text(stmt, 0) else {
            Log.info("Null data in Keymapp revision row")
            return nil
        }

        let jsonString = String(cString: blob)
        guard let jsonData = jsonString.data(using: .utf8) else { return nil }

        return parseLayoutJSON(jsonData)
    }

    // MARK: - JSON Parsing

    private func parseLayoutJSON(_ data: Data) -> KeyboardLayout? {
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            Log.info("Failed to parse Keymapp JSON")
            return nil
        }

        // Structure: { "layout": { "title", "geometry", "revision": { "layers": [...] } } }
        guard let layoutJSON = json["layout"] as? [String: Any] else {
            Log.info("No 'layout' key in Keymapp data")
            return nil
        }

        let title = layoutJSON["title"] as? String ?? "Unknown"
        guard let geometryStr = layoutJSON["geometry"] as? String,
              let geometry = KeyboardGeometry(rawValue: geometryStr) else {
            Log.info("Unknown keyboard geometry in Keymapp data")
            return nil
        }

        guard let revisionJSON = layoutJSON["revision"] as? [String: Any],
              let layersJSON = revisionJSON["layers"] as? [[String: Any]] else {
            Log.info("No layers found in Keymapp data")
            return nil
        }

        let layers = layersJSON.map { parseLayer($0) }

        Log.info("Loaded keyboard layout: \(title) (\(geometry.displayName)) with \(layers.count) layers")
        return KeyboardLayout(title: title, geometry: geometry, layers: layers)
    }

    private func parseLayer(_ json: [String: Any]) -> KeyboardLayer {
        let title = json["title"] as? String ?? ""
        let keysJSON = json["keys"] as? [[String: Any]] ?? []
        let keys = keysJSON.map { parseKeyAction($0) }
        return KeyboardLayer(title: title, keys: keys)
    }

    private func parseKeyAction(_ json: [String: Any]) -> KeyAction {
        let tapJSON = json["tap"] as? [String: Any]
        let holdJSON = json["hold"] as? [String: Any]
        let tap = parseKeyCode(tapJSON)
        let hold = parseKeyCode(holdJSON)
        // holdLayer can come from tap.layer or hold.layer
        let holdLayer = (holdJSON?["layer"] as? Int) ?? (tapJSON?["layer"] as? Int)
        let customLabel = json["customLabel"] as? String

        return KeyAction(tap: tap, hold: hold, holdLayer: holdLayer, customLabel: customLabel)
    }

    private func parseKeyCode(_ json: [String: Any]?) -> KeyCode? {
        guard let json = json, let code = json["code"] as? String else { return nil }
        if code == "KC_NO" || code == "KC_TRANSPARENT" || code == "KC_TRNS" { return nil }
        return KeyCode(code: code)
    }
}
