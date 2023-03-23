import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/quote/quote_model.dart';
import 'package:maketplace/quote/quote_viewmodel.dart';
import 'package:maketplace/utils/style.dart';
import 'package:stacked_hooks/stacked_hooks.dart' show StackedHookView;

class BacklogView extends StackedHookView<QuoteViewModel> {
  const BacklogView({
    Key? key,
  }) : super(key: key, reactive: true);

  @override
  Widget builder(
    BuildContext context,
    QuoteViewModel model,
  ) {
    return Builder(
      builder: (BuildContext context) {
        if (model.quote.pendingProducts != null) {
          return Container(
            color: Colors.white,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
              reverse: false,
              controller: model.scrollController,
              itemCount: model.quote.pendingProducts!.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const WeAreWorking();
                } else {
                  return _BacklogItemView(product: model.quote.pendingProducts![index - 1]);
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

class WeAreWorking extends StackedHookView<QuoteViewModel> {
  const WeAreWorking({Key? key}) : super(key: key, reactive: true);

  @override
  Widget builder(
    BuildContext context,
    QuoteViewModel model,
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
                _ClockTimeElapsed(dateTime: model.quote.createdAt!.toDate()),
              ],
            )
          ],
        ));
  }
}

class _ClockTimeElapsed extends StatefulWidget {
  const _ClockTimeElapsed({
    Key? key,
    required this.dateTime,
  }) : super(key: key);
  final DateTime dateTime;

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
    if (differenceStr.length >= 7) {
      differenceStr = differenceStr.substring(0, differenceStr.length - 7);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Nuestros expertos están buscando los mejores precios e inventario de tus productos.',
            style: CustomStyles.styleMuggleGray_414x400,
          ),
          TextSpan(
            text: "\nTiempo transcurrido: $differenceStr",
            style: CustomStyles.styleSafeBlue14x400,
          )
        ],
      ),
      textAlign: TextAlign.left,
    );
  }
}

class _BacklogItemView extends StackedHookView<QuoteViewModel> {
  const _BacklogItemView({Key? key, required this.product}) : super(key: key, reactive: true);

  final PendingProduct product;

  @override
  Widget builder(
    BuildContext context,
    QuoteViewModel viewModel,
  ) {
    return Container(
        margin: const EdgeInsets.only(
          top: 0,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppKeys().customColors!.muggleGray, width: 1),
          color: Colors.white,
        ),
        child: Row(
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
                    )))
          ],
        ));
  }
}
