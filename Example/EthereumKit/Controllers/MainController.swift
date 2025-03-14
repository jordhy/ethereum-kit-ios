import UIKit
import EthereumKit

class MainController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let balanceNavigation = UINavigationController(rootViewController: BalanceController())
        balanceNavigation.tabBarItem.title = "Balance"
        balanceNavigation.tabBarItem.image = UIImage(named: "Balance Tab Bar Icon")

        let transactionsNavigation = UINavigationController(rootViewController: TransactionsController())
        transactionsNavigation.tabBarItem.title = "Transactions"
        transactionsNavigation.tabBarItem.image = UIImage(named: "Transactions Tab Bar Icon")

        let sendNavigation = UINavigationController(rootViewController: SendController())
        sendNavigation.tabBarItem.title = "Send"
        sendNavigation.tabBarItem.image = UIImage(named: "Send Tab Bar Icon")

        let receiveNavigation = UINavigationController(rootViewController: ReceiveController())
        receiveNavigation.tabBarItem.title = "Receive"
        receiveNavigation.tabBarItem.image = UIImage(named: "Receive Tab Bar Icon")

        var controllers = [balanceNavigation, transactionsNavigation, sendNavigation, receiveNavigation]

        if let _ = Manager.shared.uniswapKit {
            let swapNavigation = UINavigationController(rootViewController: SwapController())
            swapNavigation.tabBarItem.title = "Swap"
            swapNavigation.tabBarItem.image = UIImage(named: "Transactions Tab Bar Icon")
            controllers.append(swapNavigation)
        }

        viewControllers = controllers
    }

}
