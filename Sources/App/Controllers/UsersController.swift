import Vapor

final class UsersController: RouteCollection {
    //create
    func createHandler(_ req: Request) throws -> Future<User> {
        return try req.content.decode(User.self).flatMap { user in
            return user.save(on: req)
        }
    }

    //read
    func getAllHandler(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).decode(User.self).all()
    }

    func getOneHandler(_ req: Request) throws -> Future<User> {
        return try req.parameters.next(User.self)
    }

    //update
    func updateHandler(_ req: Request) throws -> Future<User> {
        return try flatMap(to: User.self, 
        req.parameters.next(User.self), 
        req.content.decode(User.self)) { (user, updatedUser) in
            user.name = updatedUser.name
            user.username = updatedUser.username
            return user.save(on: req)
        }
    }

    //delete
    func deleteHandler(_ req: Request) throws -> Future<HTTPSStatus> {
        return try req.parameters.next(User.self).flatMap { user in
            return user.delete(on: req).trasform(to: HTTPSStatus.noContent)

        }
    }

    func boot(router: Router) throws {
        let usersRoute = router.grouped("api", "users")
        usersRoute.get(use: getAllHandler)
        usersRoute.get(User.parameter, use: getOneHandler)
        usersRoute.post(use: createHandler)
        usersRoute.put(User.parameter, use: updateUser)
        usersRoute.delete(User.parameter, use: deleteHandler)
    }
}