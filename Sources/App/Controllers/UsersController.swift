import Vapor

final class UsersController: RouteCollection {
    //create
    func createHandler(_ req: Request) throws -> Future<User> {
        return try req.content.decode(User.self).flatMap { user in
            return user.save(on: req)
        }
    }

    //read one
    func getOneHandler(_ req: Request) throws -> Future<User> {
        let id: Int
        do { id = try req.parameters.next(Int.self) }
        catch { throw Abort(.badRequest) }
        
        return User.find(id, on: req).flatMap({ (user) -> EventLoopFuture<User> in
            guard let user = user else {
                throw Abort(.notFound)
            }
            return user.restore(on: req)
        })
    }

    //read all
    func getAllHandler(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).decode(User.self).all()
    }

    //update
    func updateHandler(_ req: Request) throws -> Future<User> {
        return try req.content.decode(User.self).flatMap { newUser in
            guard let id = newUser.id else {
                throw Abort(.badRequest)
            }
            
            let user = User.find(id, on: req).flatMap({ (user) -> EventLoopFuture<User> in
                guard let user = user else {
                    throw Abort(.notFound)
                }
                user.name = newUser.name
                user.username = newUser.username
                
                return user.restore(on: req)
            })
            
            return user.save(on: req)
            
        }
    }

    //delete
    func deleteHandler(_ req: Request) throws -> Future<User> {
        guard let id = req.query[Int.self, at: "id"] else {
            throw Abort(.badRequest)
        }
        
        let user = User.find(id, on: req).flatMap({ (user) -> EventLoopFuture<User> in
            guard let user = user else {
                throw Abort(.notFound)
            }
            return user.restore(on: req)
        })
        
        return user.delete(on: req)
        
    }

    func boot(router: Router) throws {
        let usersRoute = router.grouped("user")
        usersRoute.get("all",use: getAllHandler)
        usersRoute.get(Int.parameter, use: getOneHandler)
        usersRoute.post(use: createHandler)
        usersRoute.put(use: updateHandler)
        usersRoute.delete(User.parameter, use: deleteHandler)
    }
}
