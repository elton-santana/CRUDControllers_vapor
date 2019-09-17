import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let usersController = UsersController()
    try router.register(collection: usersController)
    
    router.post("user") { req in
        return try usersController.createHandler(req)
    }

    router.get("users") { req in
        return try usersController.getAllHandler(req)
    }
    
    router.get("user") { req in
        return try usersController.getOneHandler(req)
    }

    router.put("user") { req in
        return try usersController.updateHandler(req)
    }
    
    router.delete("user") { req in
        return try usersController.deleteHandler(req)
    }

}
