//
//  StartStudioBridge.swift
//  onfido_sdk
//
//  Created by Pedro Henrique on 03/08/2022.
//

import Foundation
import Onfido

struct StartStudioBridge: BaseBridge {

    let name: String = "startStudio"
    func invoke(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        do {
            guard let args = call.arguments as? NSDictionary else {
                throw NSError(domain: "Invalid arguments for start studio method", code: 500)
            }

            let workflow = try WorkflowConfiguration(from: args)
            let onfidoFlow = OnfidoFlow(workflowConfiguration: workflow)

            onfidoFlow.with(responseHandler: {
                switch $0 {
                case .success(let data):
                    let serialized = data.map { $0.serialize() }
                    result(serialized)

                case .error(let error):
                    result(FlutterError(code: "error", message: error.localizedDescription, details: nil))

                case .cancel:
                    result(FlutterError(code: "exit", message: "User canceled the flow", details: nil))

                @unknown default:
                    result(FlutterError())
                }
            })

            onfidoFlow.with(eventHandler: {
                (event: Event) -> () in
                let analyticsEvent = AnalyticsEvent(eventName: event.name, properties: event.properties)
                let serializedEvent = analyticsEvent.toDictionary()
                guard let channel = SwiftOnfidoSdkPlugin.channel else { return }
                    
                DispatchQueue.main.async {
                    channel.invokeMethod("onAnalyticsCaptured", arguments: serializedEvent)
                }
            })

            getFlutterViewController()?.present(try onfidoFlow.run(), animated: true)
        } catch {
            result(FlutterError(code: "configuration", message: error.localizedDescription, details: "\(error)"))
        }
    }
}
