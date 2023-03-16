import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/notifications/notifications_service.dart';
import 'package:maketplace/notifications/notifications_viewmodel.dart';
import 'package:maketplace/utils/added_dialog.dart';
import 'package:maketplace/utils/buttons.dart';
import 'package:stacked/stacked.dart';

class BaseNotificationWidget extends StatelessWidget {
  const BaseNotificationWidget({Key? key, required this.onTapButtonUno}) : super(key: key);
  final Function()? onTapButtonUno;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotificationViewModel>.reactive(
      viewModelBuilder: () => NotificationViewModel(),
      fireOnViewModelReadyOnce: false,
      disposeViewModel: true,
      createNewViewModelOnInsert: true,
      builder: (context, model, child) {
        var media = MediaQuery.of(context).size;
        return GeneralDialog(
          text: model.notification.title,
          button1: ThirdButton(
            text: model.notification.textButtonUno,
            onPressed: onTapButtonUno ?? onTapButtonUno!(),
          ),
          button2: SecondaryButton(text: model.notification.textButtonDos, onPressed: () => Navigator.of(context).pop()),
        );
      },
    );
  }
}

class SimpleNotificationWidget extends StatelessWidget {
  const SimpleNotificationWidget({Key? key, required this.data, required this.dismissNotification}) : super(key: key);
  final NotificationModel data;
  final void Function(BuildContext context) dismissNotification;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppKeys().customColors!.safeBlue,
      margin: const EdgeInsets.symmetric(horizontal: 25),
      child: SafeArea(
        child: ListTile(
          leading: SizedBox.fromSize(
              size: const Size(40, 40),
              child: ClipOval(
                  child: Container(
                color: AppKeys().customColors!.yellowVoltz,
              ))),
          title: Text(
            data.title,
            style: GoogleFonts.inter(
              color: AppKeys().customColors!.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            data.message,
            style: GoogleFonts.inter(
              color: AppKeys().customColors!.white,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => dismissNotification(context),
          ),
        ),
      ),
    );
  }
}
