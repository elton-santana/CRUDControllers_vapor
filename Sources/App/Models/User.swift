import Vapor 
import FluentMySQL

final class User: Codable {
    var id: Int?
    var name, username: String

    init(name: String, username: String) {
        self.name = name
        self.username = username
    }
}

extension User: MySQLModel {}
extension User: Migration {}
extension User: Content {}
extension User: Parameter {}

