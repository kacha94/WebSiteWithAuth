import Fluent
import Vapor
import FluentMongoDriver

struct SeedUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let user: User
        guard let username = Environment.get("ADMIN_USERNAME"), let password = Environment.get("ADMIN_PASSWORD") else { fatalError("No value was found at the given public key environment 'ADMIN_USERNAME'") }

        do {
            user = try User(email: username, password: password)
        } catch {
            return database.eventLoop.future(error: error)
        }
        return user.save(on: database)
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return User.query(on: database)
            .filter(\.$email == "ivan@myrvold.org")
            .delete()
    }
}
