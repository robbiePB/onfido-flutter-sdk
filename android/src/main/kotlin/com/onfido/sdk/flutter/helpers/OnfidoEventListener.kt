package com.onfido.sdk.flutter.helpers

import android.os.Handler
import android.os.Looper
import com.onfido.android.sdk.capture.analytics.OnfidoAnalyticsEvent
import com.onfido.android.sdk.capture.analytics.OnfidoAnalyticsEventListener
import com.onfido.android.sdk.capture.analytics.OnfidoAnalyticsPropertyKey
import com.onfido.sdk.flutter.OnfidoPlugin

class OnfidoEventListener: OnfidoAnalyticsEventListener {

    override fun onEvent(event: OnfidoAnalyticsEvent) {
        Log.d("OnfidoEventListener", "EVENT: $event")
        val analyticsEvent = AnalyticsEvent(event.type.name, event.properties)
        println("ANALYTICS EVENT: $analyticsEvent")
        val methodChannel = OnfidoPlugin.channel
        Handler(Looper.getMainLooper()).post {
            methodChannel.invokeMethod("onAnalyticsCaptured", analyticsEvent.toFlutterResult())
        }

    }
}

data class AnalyticsEvent(val eventName: String, val properties:  Map<OnfidoAnalyticsPropertyKey, String?>) {
    fun toFlutterResult(): Map<String, *> {
        return mapOf(
            "eventName" to eventName,
            "properties" to properties.mapKeys { it.key.name }
        )
    }
}