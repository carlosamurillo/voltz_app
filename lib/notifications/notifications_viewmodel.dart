
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart' show ReactiveViewModel, ListenableServiceMixin;
import 'package:stacked_services/stacked_services.dart' show NavigationService;
import '../app/app.locator.dart';
import 'notifications_service.dart';

class NotificationViewModel extends ReactiveViewModel {
  final _notificationService = locator<NotificationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  List<ListenableServiceMixin> get listenableServices => [_notificationService,];

  NotificationModel get notification => _notificationService.getCopyOfNotification();

  void dismissNotification(context) async {
    OverlaySupportEntry.of(context)?.dismiss();
    _notificationService.reset();
  }

}