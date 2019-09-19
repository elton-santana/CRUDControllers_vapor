import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let usersController = UsersController()
    do{
        try router.register(collection: usersController)
    } catch(let error) {
        print(error.localizedDescription)
    }


}
