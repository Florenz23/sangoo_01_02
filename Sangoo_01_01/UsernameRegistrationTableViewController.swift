import UIKit
import RealmSwift
import SkyFloatingLabelTextField


class UsernameRegistrationTableViewController: UITableViewController, UITextFieldDelegate {
    
    //textFields
    
    var uiFields = UIRegistration()
    
    var userData = RegistrationUserData()
    var authData = AuthData()
    var authDataList = List<AuthData>()
    var realm: Realm!
    var notificationToken: NotificationToken!
    var loadingAnimation = LoadingAnimation()
    var realmHelper = RealmHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRealm(syncUser: SyncUser.current!)
    }
    
    
    func setupUI() {
        // Do any additional setup after loading the view, typically from a nib.
        title = ""
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "demoCell")
        tableView.backgroundColor = UIColor(red: 0.949,green: 0.949,blue: 0.949,alpha: 1)
        // delete border
        tableView.separatorStyle = .none
        
        
        let textFieldDescription = "Nutzername"
        let guardedData = authData.userName
        uiFields.setupTextField(description : textFieldDescription, text : guardedData)
        uiFields.textField.delegate = self
        
        uiFields.setupButton()
        uiFields.disableButton()
        uiFields.button.addTarget(self, action: #selector(nextButtonTapped), for: .touchDown)
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                // nötig, damit die aktuellen Daten aus Texfeld benutzt werden
                var txtAfterUpdate:NSString = text as String! as NSString
                txtAfterUpdate = txtAfterUpdate.replacingCharacters(in: range, with: string) as NSString
                print(txtAfterUpdate)
                if(!checkUniqueUserName(text: txtAfterUpdate as String)) {
                    floatingLabelTextField.errorMessage = "Benutzername leider schon vergeben..."
                    uiFields.disableButton()
                }
                else {
                    // The error message will only disappear when we reset it to nil or empty string
                    floatingLabelTextField.errorMessage = ""
                    self.uiFields.enableButton()
                }
            }
        }
        return true
    }
    
    func checkUniqueUserName(text : String) -> Bool {
        let filterString = "userName == '\(text as String)'"
        print(filterString)
        let user = realm.objects(AuthData.self).filter(filterString)
        
        if (user.count == 0) {
            print("ok")
            return true
        }
        
        return false
    }
    
    func setupRealm(syncUser : SyncUser) {
        self.realm = self.realmHelper.iniRealm(syncUser: syncUser)
        
    }
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func nextButtonTapped(_ button: UIButton) {
        print("Weiter pressed 👍")
        guardData()
        goToNextView()
    }
    
    func guardData () {
        
        authData.userName = uiFields.textField.text!
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "demoCell", for: indexPath)
        //disableSelection
        cell.selectionStyle = .none
        
        
        if indexPath.row == 0 {
            cell.addSubview(uiFields.textField)
        }
        else if indexPath.row == 1 {
            cell.addSubview(uiFields.button)
        }
        else if indexPath.row == 2 {
            cell.addSubview(loadingAnimation.animation)
            //cell.textLabel?.text = "Moin"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        } else if indexPath.row == 1 {
            return 80
        } else {
            return 50
        }
    }
    
    
    func goToNextView() {
        
        let v = PasswordRegistrationTableViewController()
        v.userData = userData
        v.authData = authData

        navigationController?.pushViewController(v, animated: true)
        
    }
    
}
