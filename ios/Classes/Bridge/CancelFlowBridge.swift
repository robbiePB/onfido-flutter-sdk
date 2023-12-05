import Foundation
import Onfido

struct CancelFlowBridge: BaseBridge {

    let name: String = "cancelFlow"
    func invoke(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
            do {
                getFlutterViewController()?.dismiss(animated: true, completion: {
                guard let channel = SwiftOnfidoSdkPlugin.channel else { return }
                      DispatchQueue.main.async {
                    channel.invokeMethod("onFlowCancelled", arguments: nil)
                }
                })
            } catch {
                result(FlutterError(code: "configuration", message: error.localizedDescription, details: "\(error)"))
            }
        } 
}