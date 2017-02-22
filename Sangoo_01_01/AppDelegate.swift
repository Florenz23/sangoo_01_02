import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:[UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        if configureDefaultRealm() {
            print("User already authed")
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = CustomTabBarController()
            window?.makeKeyAndVisible()
        } else {
            print("First Login")
            window?.rootViewController = CustomTabBarController()
            window?.makeKeyAndVisible()
            logIn(animated: false)
        }
        return true
        
        
//        let nav1 = UINavigationController()
//        let mainView = LandingPageTableViewController(nibName: nil, bundle: nil) //ViewController = Name of your controller
//        nav1.viewControllers = [mainView]
////        window?.rootViewController = nav1
//        
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.makeKeyAndVisible()
//        window?.rootViewController = CustomTabBarController()

    }
    
    func logIn(animated: Bool = true) {
        let username = "test@gmx.de"  // <--- Update this
        let password = "asdfasdf"  // <--- Update this
           // guard response.returnCode != .cancel, let username = response.username, let password = password else {
                // FIXME: handle cancellation properly or just restrict it
           //     DispatchQueue.main.async {
           //         self.logIn()
           //     }
           //     return
           // }
        authenticate(username: username, password: password, register: false) { error in
            if let error = error {
                self.present(error: error)
                print("Login error")
                print(error)
            } else {
                
                self.window?.rootViewController = LandingPageTableViewController()
            }
        }
        //window?.rootViewController?.present(LandingPageTableViewController(), animated: false, completion: nil)
    }
    
    func present(error: NSError) {
        print(error)
        print("Fehler beim anmelden")
//        let alertController = UIAlertController(title: error.localizedDescription,
//                                                message: error.localizedFailureReason ?? "",
//                                                preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "Try Again", style: .default) { _ in
//            self.logIn()
//        })
        window?.rootViewController?.present(CustomTabBarController(), animated: true, completion: nil)
    }

}
