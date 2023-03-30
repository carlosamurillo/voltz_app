import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart' show ListenableServiceMixin;

class NotificationService with ListenableServiceMixin {
  // final _rxNotification = RxValue<NotificationModel>(NotificationModel.withButtons('', '', false, NotificationType.simple, '', ''));
  final _rxNotification = RxValue<NotificationModel>(NotificationModel.simple('', '', false, NotificationType.simple));

  NotificationModel get notification => _rxNotification.value;

  NotificationService() {
    listenToReactiveValues([_rxNotification]);
  }

  NotificationModel getCopyOfNotification() => _rxNotification.value;

  void emitSimpleNotification(String title, String message) {
    _rxNotification.value = NotificationModel.simple(title, message, true, NotificationType.simple);
    notifyListeners();
  }

  void reset() {
    // _rxNotification.value = NotificationModel.withButtons('', '', false, NotificationType.simple, '', '');
    _rxNotification.value = NotificationModel.simple('', '', false, NotificationType.simple);

    notifyListeners();
  }

  void emitDialogNotification(String title, String textButtonUno, String textButtonDos, bool showButtons) {
    _rxNotification.value = NotificationModel.withButtons(title, '', true, NotificationType.dialog, textButtonUno, textButtonDos, showButtons);
    notifyListeners();
  }
}

enum NotificationType {
  simple,
  dialog,
  enhance;

  static NotificationType? fromString(String value) {
    switch (value) {
      case 'simple':
        return NotificationType.simple;
      case 'dialog':
        return NotificationType.dialog;
      case 'enhance':
        return NotificationType.enhance;
      default:
        return null;
    }
  }
}

class NotificationModel {
  String title = '';
  String textButtonUno = '';
  String textButtonDos = '';
  String message = '';
  bool showNotification = false;
  bool showButtons;
  NotificationType type = NotificationType.simple;

  NotificationModel.simple(
    this.title,
    this.message,
    this.showNotification,
    this.type, [
    this.showButtons = false,
  ]);
  NotificationModel.withButtons(
    this.title,
    this.message,
    this.showNotification,
    this.type,
    this.textButtonUno,
    this.textButtonDos,
    this.showButtons,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationModel &&
        other.title == title &&
        other.textButtonUno == textButtonUno &&
        other.textButtonDos == textButtonDos &&
        other.message == message &&
        other.showNotification == showNotification &&
        other.showButtons == showButtons &&
        other.type == type;
  }

  @override
  int get hashCode => title.hashCode ^ textButtonUno.hashCode ^ textButtonDos.hashCode ^ message.hashCode ^ showNotification.hashCode ^ showButtons.hashCode ^ type.hashCode;
}
