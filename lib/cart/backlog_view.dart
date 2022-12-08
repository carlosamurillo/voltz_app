import 'dart:async';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:maketplace/quote/quote_model.dart';
import 'package:maketplace/quote/quote_viewmodel.dart';
import 'package:maketplace/utils/style.dart';
import '../utils/custom_colors.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class BacklogView extends HookViewModelWidget<QuoteViewModel> {
  BacklogView({Key? key, }) : super(key: key, reactive: true);

  @override
  Widget buildViewModelWidget(
      BuildContext context,
      QuoteViewModel viewModel,
      ) {
    return Builder(
          builder: (BuildContext context) {
            if (viewModel.quote.pendingProducts != null) {
              return
                Container(
                  color: Colors.white,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                    reverse: false,
                    controller: viewModel.scrollController,
                    itemCount: viewModel.quote.pendingProducts!.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return const WeAreWorking();
                      } else {
                        return _BacklogItemView(product: viewModel.quote.pendingProducts![index]);
                      }
                    },
                  ),
                );
            } else {
              return const CircularProgressIndicator();
            }
          },
        );
  }
}
class WeAreWorking extends HookViewModelWidget<QuoteViewModel> {
  const WeAreWorking({Key? key}) : super(key: key, reactive: true);

  @override
  Widget buildViewModelWidget(
      BuildContext context,
      QuoteViewModel viewModel,
      ) {
    return Container(
        margin: const EdgeInsets.only(top: 30, bottom: 30),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: const Color(0xFF2763FC).withOpacity(0.1),
        ),
        width: double.infinity,
        child: Row(
          children: [
            Image.asset(
              'assets/images/assistant_icon.png',
              width: 48.0,
              height: 48.0,
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  'Estamos trabajando para tí.',
                  style: CustomStyles.styleMuggleGray_416x700,
                  textAlign: TextAlign.left,
                  //overflow: TextOverflow.clip,
                ),
                _ClockTimeElapsed(dateTime: viewModel.quote.createdAt!.toDate()),
              ],
            )
          ],
        )
    );
  }
}

class _ClockTimeElapsed extends StatefulWidget {
  _ClockTimeElapsed({Key? key, required this.dateTime,}) : super(key: key);
  DateTime dateTime;

  @override
  _ClockTimeElapsedState createState() => _ClockTimeElapsedState();
}
class _ClockTimeElapsedState extends State<_ClockTimeElapsed> {
  late Duration difference;
  String differenceStr = '';
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    calculateDifference();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        calculateDifference();
      });
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    _timer.cancel();
    super.dispose();
  }


  calculateDifference() {
    difference = DateTime.now().difference(widget.dateTime);
    differenceStr = difference.toString();
    if (differenceStr != null && differenceStr.length >= 7) {
      differenceStr = differenceStr.substring(0, differenceStr.length - 7);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
        children: [
          TextSpan(text: 'Nuestros expertos están buscando los mejores precios e inventario de tus productos.',
            style: CustomStyles.styleMuggleGray_414x400,),
          TextSpan(text: "\nTiempo transcurrido: $differenceStr",
            style: CustomStyles.styleSafeBlue14x400,)
        ],
      ),
      textAlign: TextAlign.left,
    );
  }
}



class _BacklogItemView extends HookViewModelWidget<QuoteViewModel> {
  const _BacklogItemView({Key? key, required this.product }) : super(key: key, reactive: true);

  final PendingProduct product;

  @override
  Widget buildViewModelWidget(
      BuildContext context,
      QuoteViewModel viewModel,
      ) {

    return Container(
        margin: const EdgeInsets.only(top: 0,),
        decoration: BoxDecoration(
          border: Border.all(color: CustomColors.muggleGray, width: 1),
          color: Colors.white,
        ),
        child:  Row (
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: SvgPicture.asset(
                'assets/svg/cube_icon.svg',
                width: 23,
                height: 24,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: SelectableText(
                  product.requestedProduct!.replaceAll("<em>", "").replaceAll("<\/em>", ""),
                  style: CustomStyles.styleVolcanic16x400,
                  textAlign: TextAlign.left,
                  //overflow: TextOverflow.clip,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: TextButton(
                  onPressed: () async {
                    viewModel.onDeleteSkuFromPending(product);
                    viewModel.notifyListeners();
                  },
                  child: Text(
                    'Descartar',
                    style: CustomStyles.styleRedAlert16x400Underline,
                  )
              )
            )
          ],
        )
    );
  }

}
