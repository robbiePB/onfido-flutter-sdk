import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:onfido_sdk/onfido_sdk.dart';
import 'package:onfido_sdk/src/serializer/onfido_analytics_event_serializer.dart';
import 'package:onfido_sdk/src/serializer/serializer.dart';

class MethodChannelOnfido extends OnfidoPlatform {
  static MethodChannel? _methodChannel;

  @visibleForTesting
  static MethodChannel get methodChannel {
    if (_methodChannel == null) {
      _methodChannel = const MethodChannel('onfido_sdk');
      _methodChannel!.setMethodCallHandler(platformCallHandler);
    }
    return _methodChannel!;
  }

  static OnfidoMediaCallback? _mediaCallback;
  static OnfidoAnalyticsCallback? _analyticsCallback;

  @override
  Future<List<OnfidoResult>> start({
    required String sdkToken,
    required FlowSteps flowSteps,
    String? iosLocalizationFileName,
    IOSAppearance? iosAppearance,
    OnfidoMediaCallback? mediaCallback,
    EnterpriseFeatures? enterpriseFeatures,
    bool? disableNFC,
    OnfidoTheme? onfidoTheme,
    OnfidoAnalyticsCallback? analyticsCallback,
  }) async {
    final arguments = StartOptionsSerializer.serialize(
        sdkToken: sdkToken,
        flowSteps: flowSteps,
        iosAppearance: iosAppearance,
        shouldUseMediaCallback: mediaCallback != null,
        iosLocalizationFileName: iosLocalizationFileName,
        enterpriseFeatures: enterpriseFeatures,
        disableNFC: disableNFC,
        onfidoTheme: onfidoTheme);

    _mediaCallback = mediaCallback;
    _analyticsCallback = analyticsCallback;

    final result = await methodChannel.invokeMethod('start', arguments);
    return OnfidoResultSerializer.deserialize(result);
  }

  @override
  Future<void> startWorkflow({
    required String sdkToken,
    required String workflowRunId,
    IOSAppearance? iosAppearance,
    OnfidoMediaCallback? mediaCallback,
    String? iosLocalizationFileName,
    EnterpriseFeatures? enterpriseFeatures,
    OnfidoTheme? onfidoTheme,
    OnfidoAnalyticsCallback? analyticsCallback,
  }) async {
    final arguments = StartStudioSerializer.serialize(
        sdkToken: sdkToken,
        workflowRunId: workflowRunId,
        iosAppearance: iosAppearance,
        shouldUseMediaCallback: mediaCallback != null,
        iosLocalizationFileName: iosLocalizationFileName,
        enterpriseFeatures: enterpriseFeatures,
        onfidoTheme: onfidoTheme);

    _mediaCallback = mediaCallback;
    _analyticsCallback = analyticsCallback;

    await methodChannel.invokeMethod('startStudio', arguments);
  }

  @override
  Future<void> cancelFlow() async {
    await methodChannel.invokeMethod('cancelFlow');
  }

  static Future<void> platformCallHandler(MethodCall call) {
    try {
      switch (call.method) {
        case 'onMediaCaptured':
          {
            if (kDebugMode) {
              print('onMediaCaptured call handler');
            }
            final OnfidoMediaResult result =
                OnfidoMediaResultSerializer.deserialize(call.arguments);
            _mediaCallback?.onMediaCaptured(result: result);
            break;
          }
        case 'onAnalyticsCaptured':
          {
            if (kDebugMode) {
              print('onAnalyticsCaptured call handler');
            }
            final OnfidoAnalyticsEvent event =
                OnfidoAnalyticsEventSerializer.deserialize(call.arguments);
            _analyticsCallback?.onEvent(event: event);
            break;
          }
        default:
          if (kDebugMode) {
            print('Unknown method ${call.method} ');
          }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return Future.value();
  }
}
