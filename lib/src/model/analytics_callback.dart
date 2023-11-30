import 'package:onfido_sdk/src/model/analytics_event.dart';

abstract class OnfidoAnalyticsCallback {
  void onEvent({required OnfidoAnalyticsEvent event});
}
