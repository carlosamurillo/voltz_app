
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart' show ListenableServiceMixin;

class NotificationService with ListenableServiceMixin {
  final _rxTitle = RxValue<String>('');
  final _rxMessage = RxValue<String>('');
  final _rxShowNotification = RxValue<bool>(false);
  String get title => _rxTitle.value;
  String get message => _rxMessage.value;
  bool get showNotification => _rxShowNotification.value;

  NotificationService() {
    listenToReactiveValues([_rxTitle, _rxMessage, _rxShowNotification]);
  }

  final _rxType = RxValue<NotificationType>(NotificationType.simple);
  NotificationType get type => _rxType.value;

  void emitSimpleNotification(String title, String message) async {
    _rxType.value = NotificationType.simple;
    _rxTitle.value = title;
    _rxMessage.value = message;
    _rxShowNotification.value = true;
    notifyListeners();
  }

  void reset() async {
    _rxTitle.value = '';
    _rxMessage.value = '';
    _rxShowNotification.value = false;
    notifyListeners();
  }
}

enum NotificationType {
  simple,
  medium,
  enhance,
}