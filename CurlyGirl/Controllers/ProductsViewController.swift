


import UIKit
import RealmSwift
import MBProgressHUD
import SDWebImage


class ProductsViewController: UIViewController {
    
    @IBOutlet weak var productTableView: UITableView!
    var notificationToken: NotificationToken? = nil
    var products : Results<Product>!
    var processingLoader: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Products"
        
        productTableView.tableFooterView = UIView()
        
        showProcessingLoader()
        
        fetchProductsFromServer()
        
        
        products = RealmHelper.objects(type: Product.self)
        
        // Observe Results Notifications
        notificationToken =  products.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.productTableView else { return }
            switch changes {
            case .initial:
                tableView.delegate = self
                tableView.dataSource = self
                tableView.reloadData()
                
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                print(error)
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
        let product = products[indexPath.row]
        
        cell.textLabel?.text = product.name
        cell.detailTextLabel?.text = product.type
        cell.imageView?.sd_setShowActivityIndicatorView(true)
        cell.imageView?.sd_setIndicatorStyle(.gray)
        cell.imageView?.sd_setImage(with: URL(string: product.link)) { (image, error, cache, urls) in
            if(error != nil){
                cell.imageView?.image = UIImage(named: "img_broken")
            } else {
                cell.imageView?.image = image
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension ProductsViewController {
    
    func fetchProductsFromServer(){
        HairAPI.get(url: PRODUCTS_API, type: Product.self, success: {
            self.processingLoader.hide(animated: true)
        }) { (error) in
            self.processingLoader.hide(animated: true)
            self.showAlertWithMessage("There was an error!")
        }
    }
    fileprivate func showProcessingLoader(){
        processingLoader = MBProgressHUD.showAdded(to: view, animated: true)
        processingLoader.mode = MBProgressHUDMode.indeterminate
        processingLoader.label.text = "Fetching..."
    }
    fileprivate func showAlertWithMessage(_ message: String){
        let alert = UIAlertController(title: "Sorry", message: message , preferredStyle: .alert)
        let yesButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(yesButton)
        present(alert, animated: true, completion: nil)
    }
}

