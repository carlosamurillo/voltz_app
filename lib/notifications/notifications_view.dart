
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: SafeArea(
            child: ListTile(
              leading: SizedBox.fromSize(
                  size: const Size(40, 40),
                  child: ClipOval(
                      child: Container(
                        color: Colors.black,
                      ))),
              title: Text(model.title),
              subtitle: Text(model.message),
              trailing: IconButton(
                  icon: const Icon(Icons.close),
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
