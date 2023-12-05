import Foundation
import Onfido

struct CancelFlowBridge: BaseBridge {

    let name: String = "cancelFlow"
    func invoke(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
            do {
                getFlutterViewController()?.dismiss(animated: true)
            } catch {
                result(FlutterError(code: "configuration", message: error.localizedDescription, details: "\(error)"))
            }
        } 
}