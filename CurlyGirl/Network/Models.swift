import Foundation
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public var HAIR_API_URL = "https://powerful-lowlands-35362.herokuapp.com/"
public var PRODUCTS_API                                      = HAIR_API_URL + "products"
public var HAIR_POROSITY_RESULT_API                          = HAIR_API_URL + "rand"


//MARK:- Low Porosity Product
class Product: Object, Mappable {
    @objc dynamic var type                                        = ""
    @objc dynamic var link                                        = ""
    @objc dynamic var name                                        = ""
   
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override class func primaryKey() -> String?{
        return "name"
    }
    func mapping(map: Map) {
        type                                         <- map["type"]
        link                                         <- map["link"]
        name                                        <- map["name"]
        
    }
}



