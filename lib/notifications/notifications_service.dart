
import 'package:maketplace/utils/added_dialog.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart' show ListenableServiceMixin;

class NotificationService with ListenableServiceMixin {
  final _rxNotification = RxValue<NotificationModel>(NotificationModel.name('', '', false, NotificationType.simple));
  NotificationModel get notification => _rxNotification.value;

  NotificationService() {
    listenToReactiveValues([_rxNotification,]);
  }

  NotificationModel getCopyOfNotification(){
    return NotificationModel.copyWith(
        _rxNotification.value.toJson());
  }

  void emitSimpleNotification(String title, String message) async {
    _rxNotification.value = NotificationModel.name(title, message, true, NotificationType.simple);
    notifyListeners();
  }

  void reset() async {
    _rxNotification.value = NotificationModel.name('', '', false, NotificationType.simple);
    notifyListeners();
  }
  
  void emitDialogNotification(String title, String textButtonUno, String textButtonDos) async {
    _rxNotification.value = NotificationModel.name(title, '', true, NotificationType.dialog);
    notifyListeners();
  }
}

enum NotificationType {
  simple,
  dialog,
  enhance;

  static NotificationType? fromString(String value) {
    switch (value){
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
  NotificationType type = NotificationType.simple;

  NotificationModel.name(this.title, this.message, this.showNotification, this.type);

  NotificationModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    textButtonUno = json['text_button_uno'];
    textButtonDos = json['text_button_dos'];
    message = json['message'];
    showNotification = json['show_notification'];
    type = NotificationType.fromString(json['type'])!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['message'] = this.message;
    data['show_notification'] = this.showNotification;
    data['type'] = this.type.name;
    data['text_button_uno'] = this.textButtonUno;
    data['text_button_dos'] = this.textButtonDos;
    return data;
  }

  static NotificationModel copyWith(Map<String, dynamic> json) {
    return NotificationModel.fromJson(json);
  }
}