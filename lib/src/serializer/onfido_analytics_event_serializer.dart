import 'package:onfido_sdk/src/model/analytics_event.dart';

class OnfidoAnalyticsEventSerializer {
  static OnfidoAnalyticsEvent deserialize(dynamic value) {
    return OnfidoAnalyticsEvent(
      eventName: value['eventName'],
      properties: value['properties'],
    );
  }
}
