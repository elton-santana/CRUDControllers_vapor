import Vapor 
import FluentSQLite

final class User: Codable {
    var id: Int?
    var name, username: String

    init(name: String, username: String) {
        self.name = name
        self.username = username
    }
}

extension User: SQLiteModel {}
extension User: Migration {}