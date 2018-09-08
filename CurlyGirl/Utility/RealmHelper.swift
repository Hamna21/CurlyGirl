import Foundation
import RealmSwift

class RealmHelper {
    
    static let realm = try! Realm()
    
    // Get object from default realm database according to the input
    static func objects<T: Object>(type: T.Type) -> Results<T>? {
        return realm.objects(type)//.sorted(byKeyPath: "createdAt")
    }
    
    // Delete all object in default realm database
    static func deletAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    static func deleteObject(_ object: Object, success: @escaping()-> Void, fail: @escaping(_ error: NSError) -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(object)
                success()
            }
        } catch let error as NSError {
            fail(error)
        }
    }
    
    // write single object to database
    static func writeToDB(object: Object, success: @escaping() -> Void, fail: @escaping (_ error: NSError) -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(object, update: true)
                success()
            }
        } catch let error as NSError {
            fail(error)
        }
    }
    
    // write a array of object to database
    static func writeToDB(objects: [Object], success: @escaping() -> Void, fail: @escaping (_ error: NSError) -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                for object in objects {
                    realm.add(object, update: true)
                }
                
                success()
            }
        } catch let error as NSError {
            fail(error)
        }
    }
  
}
