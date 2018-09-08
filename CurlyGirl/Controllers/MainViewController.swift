import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func findHairPorosityButtonPressed(_ sender: Any) {
        let resultVC = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    @IBAction func checkHairProductsButtonPressed(_ sender: Any) {
        let productsVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
        
        self.navigationController?.pushViewController(productsVC, animated: true)
    }
    
    
}

