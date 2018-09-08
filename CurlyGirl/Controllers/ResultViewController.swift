import UIKit
import RealmSwift
import MBProgressHUD

class ResultViewController: UIViewController {
    
    @IBOutlet weak var questionsTableView: UITableView!
    @IBOutlet weak var submitButton: LoadingButton!
    
    let questions = [
    "Hair absorbs products easily", "Hair takes longer to dry", "Need more conditioner", "Hair chemically processed", "Gaps between hair strand"
    ]
    
    var hairPorosityResults = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionsTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        submitButton.isEnabled = false
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        questionsTableView.alpha = 0.5
        questionsTableView.isUserInteractionEnabled = false
        submitButton.isEnabled = false
        
        submitButton.showLoading()
        
        for index in questionsTableView.indexPathsForSelectedRows! {
            hairPorosityResults.append(index.row)
        }
        
        sendResultToServer()
        
    }
    
}

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionTableViewCell
        cell.questionLabel.text = questions[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        submitButton.isEnabled = tableView.indexPathsForSelectedRows?.count != nil
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        submitButton.isEnabled = tableView.indexPathsForSelectedRows?.count != nil
        
    }
    
    
    
    func sendResultToServer(){
        HairAPI.hairResult(quiz: hairPorosityResults, success: { (type) in
            self.showResultAlert("Your hair type is: \(type)")
        }) { (errorString) in
           self.showAlertWithMessage("There was a problem")
        }
        
    }
    
    fileprivate func showAlertWithMessage(_ message: String){
        let alert = UIAlertController(title: "Sorry", message: message , preferredStyle: .alert)
        let yesButton = UIAlertAction(title: "Try Again!", style:.default){ (Void) in
            self.questionsTableView.alpha = 1
            self.questionsTableView.isUserInteractionEnabled = true
            self.submitButton.isEnabled = true
            self.submitButton.hideLoading()
        }
        
        alert.addAction(yesButton)
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func showResultAlert(_ message: String){
        let alert = UIAlertController(title: "Hair Porosity Result", message: message , preferredStyle: .alert)
        let yesButton = UIAlertAction(title: "OK", style:.default){ (Void) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        alert.addAction(yesButton)
        present(alert, animated: true, completion: nil)
    }
}




