import UIKit
import RealmSwift
import SkyFloatingLabelTextField


class PasswordRegistrationTableViewController: UITableViewController,UITextFieldDelegate {
    
    //textFields
    var uiFields = UIRegistration()

    
    var user = User()
    var userData = UserData()
    var authData = AuthData()
    
    var realm: Realm!
    var notificationToken: NotificationToken!
    var loadingAnimation = LoadingAnimation()
    
    var cookie = LocalCookie()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        //iniDummy()
        setupRealm()
    }
    
    func nextButtonTapped(_ button: UIButton) {
        print("Weiter pressed 👍")
        guardData()
        saveData()
        setLocalCookie()
        goToNextView()
    }
    
    
    func saveData() {
        print("save try")
        
        user.userId = authData.userId
        user.userData = userData
        
        print(user)
        
        try! realm.write {
            //authData.insert(AuthData(value: ["userId": NSUUID().uuidString, "userName": userName.text, "userPassword": userPassword.text]), at: 0)
            realm.add(self.authData)
        }
        try! realm.write {
            //authData.insert(AuthData(value: ["userId": NSUUID().uuidString, "userName": userName.text, "userPassword": userPassword.text]), at: 0)
            realm.add(self.user)
        }
    }

    
    func setupRealm() {
        
        setRealm(user: SyncUser.current!)
        //defineUpdateList()
        
    }
    
    func setRealm(user : SyncUser) {
        
        DispatchQueue.main.async {
            // Open Realm
            let configuration = Realm.Configuration(
                syncConfiguration: SyncConfiguration(user: user, realmURL: URL(string: "realm://10.0.1.4:9080/~/sangoo")!)
            )
            self.realm = try! Realm(configuration: configuration)
            
        }
        
    }
    
    
    func setLocalCookie() -> Void {
        
        cookie.setLocalCookie(userId: authData.userId)
        
        
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
        
        
        let textFieldDescription = "Password"
        let guardedData = authData.userPassword
        uiFields.setupTextField(description : textFieldDescription, text : guardedData)
        //uiFields.textField.delegate = self
        uiFields.textField.isSecureTextEntry = true
        uiFields.textField.becomeFirstResponder()
        uiFields.textField.delegate = self
        uiFields.textField.becomeFirstResponder()


        
        uiFields.setupButton()
        uiFields.button.setTitle("Registrieren", for: .normal)
        uiFields.disableButton()
        uiFields.button.addTarget(self, action: #selector(nextButtonTapped), for: .touchDown)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                // nötig, damit die aktuellen Daten aus Texfeld benutzt werden
                var txtAfterUpdate:NSString = text as String! as NSString
                txtAfterUpdate = txtAfterUpdate.replacingCharacters(in: range, with: string) as NSString
                if (text.characters.count < 5) {
                    floatingLabelTextField.errorMessage = "Wähle bitte ein längeres Passwort ..."
                    self.uiFields.disableButton()
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

    
    func goToNextView() {
        
        let v = CustomTabBarController()
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(v, animated: true)
        
    }
    
    func iniDummy() {
        authData.userName = "Igor"
        authData.userPassword = "haha"
        
        userData.userId = authData.userId
        userData.userFirstName = "Hans"
        userData.userLastName = "Peter"
        userData.userEmail = "Hans"
        userData.userPhone = "Hans"
    }

    
    
    
    func guardData () {
        
        authData.userPassword = uiFields.textField.text!
        
    }
    
    // MARK: - Table view data source

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
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
    
    
    
    
}
