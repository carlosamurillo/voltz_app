
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maketplace/utils/custom_colors.dart';
import 'package:stacked/stacked.dart';
import 'notifications_viewmodel.dart';

class SimpleNotificationWidget extends StatelessWidget {
  const SimpleNotificationWidget({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotificationViewModel>.reactive(
      viewModelBuilder: () => NotificationViewModel(),
      fireOnViewModelReadyOnce: false,
      builder: (context, model, child) {
        var media = MediaQuery.of(context).size;
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
                model.title,
                style: GoogleFonts.inter(
                  color: CustomColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),),
              subtitle: Text(
                model.message,
                style: GoogleFonts.inter(
                  color: CustomColors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),),
              trailing: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    model.dismissNotification(context);
                  }),
            ),
          ),
        );
      },
    );
  }
}
