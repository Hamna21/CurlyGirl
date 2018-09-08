import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

import RealmSwift


class HairAPI {
    
    //Getting objects Array of ANY type
    public static func get<T: Object>(url: String, type: T.Type, success: @escaping() -> Void, fail: @escaping(_ error: NSError) -> Void) -> Void where T: Mappable {
       
        Alamofire.request(url, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseArray { (response: DataResponse<[T]>) in
            switch response.result {
            case .success(let items):
                autoreleasepool {
                    print(items)
                    RealmHelper.writeToDB(objects: items, success: {
                        success()
                        return
                    }, fail: { (error) in
                        fail(error)
                        return
                    })
                }
                
            case .failure(let error):
                fail(error as NSError)
                
            }
        }
    }
    
    public static func hairResult(quiz: [Int],success: @escaping(_ type: String)->Void, fail: @escaping(_ errorString: String)->Void) -> Void {
        let parameters : [String: Any] = ["quiz" : quiz]
        Alamofire.request(HAIR_POROSITY_RESULT_API, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                print(response.result)
                switch response.result {
                case .success:
                    if let result = response.result.value {

                        let JSON = result as! NSDictionary
                        
                        guard let status = JSON["number"] as? Int else {
                            fail("status not found")
                            return
                        }
                        if(status == 0){
                            success("low")
                            return
                        } else {
                            success("high")
                            return
                        }
                    } else {
                        fail("error")
                        return
                        
                    }
                    
                case .failure(let error):
                    fail(error.localizedDescription)
                    return
                }
        }
        
    }

    
   


}
