package com.onfido.sdk.flutter.bridge

import com.onfido.sdk.flutter.api.FlutterActivityProvider
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.onfido.sdk.flutter.OnfidoPlugin

internal class CancelFlowMethod(
    private val activityProvider: FlutterActivityProvider
) : BaseMethod {
    override val name: String = "cancelFlow"

    companion object {
        const val startRequestCode: Int = 907040
    }

    override fun invoke(call: MethodCall, result: MethodChannel.Result) {
        val activity = activityProvider.provide() ?: throw Exception("Invalid activity")
        activity.finish()
        
        val methodChannel = OnfidoPlugin.channel
        methodChannel.invokeMethod("onFlowCancelled", null)
    }
}