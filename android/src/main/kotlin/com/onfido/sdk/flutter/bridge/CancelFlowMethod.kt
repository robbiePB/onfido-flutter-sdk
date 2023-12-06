package com.onfido.sdk.flutter.bridge

import android.os.Handler
import android.os.Looper
import com.onfido.sdk.flutter.api.FlutterActivityProvider
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

internal class CancelFlowMethod(
    private val activityProvider: FlutterActivityProvider,
    private val methodChannel: MethodChannel
) : BaseMethod {
    override val name: String = "cancelFlow"

    companion object {
        const val startRequestCode: Int = 207040
    }

    override fun invoke(call: MethodCall, result: MethodChannel.Result) {
        val activity = activityProvider.provide() ?: throw Exception("Invalid activity")
        activity.finish()
        
        Handler(Looper.getMainLooper()).post {
            methodChannel.invokeMethod("onFlowCancelled", null)
        }
    }
}