
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maketplace/utils/custom_colors.dart';
import 'package:stacked/stacked.dart';
import 'notifications_service.dart';
import 'notifications_viewmodel.dart';

class BaseNotificationWidget extends StatelessWidget {
  const BaseNotificationWidget({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotificationViewModel>.reactive(
      viewModelBuilder: () => NotificationViewModel(),
      fireOnViewModelReadyOnce: false,
      disposeViewModel: true,
      createNewViewModelOnInsert: true,
      builder: (context, model, child) {
        var media = MediaQuery.of(context).size;
        return SimpleNotificationWidget(data: model.notification, dismissNotification: model.dismissNotification);
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
      color: CustomColors.safeBlue,
      margin: const EdgeInsets.symmetric(horizontal: 25),
      child: SafeArea(
        child: ListTile(
          leading: SizedBox.fromSize(
              size: const Size(40, 40),
              child: ClipOval(
                  child: Container(
                    color: CustomColors.yellowVoltz,
                  ))),
          title: Text(
            data.title,
            style: GoogleFonts.inter(
              color: CustomColors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),),
          subtitle: Text(
            data.message,
            style: GoogleFonts.inter(
              color: CustomColors.white,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),),
          trailing: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => dismissNotification(context),
        ),
      ),
    ),);
  }
}
