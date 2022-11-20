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
                        return WeAreWorking(createdAt: viewModel.quote.createdAt!,);
                      } else {
                        return BacklogItemView(viewModel: viewModel, i: index,);
                      }
                    },
                  ),
                );
            } else {
              return true ?
              const CircularProgressIndicator(): Container(
                  padding: EdgeInsets.all(80),
                  color: CustomColors.backgroundCanvas,
                  alignment: Alignment.center,
                  child: Container(
                    color: Colors.white,
                    child: Text('Ups!, sin resultados. Intenta con otros filtros...',
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                      style: CustomStyles.styleVolcanicUno,
                    ),
                  ));
            }
          },
        );
  }
}

class WeAreWorking extends StatelessWidget {
  const WeAreWorking({required this.createdAt });
  final Timestamp createdAt;

  @override
  Widget build(BuildContext context) {
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
                  'Estamos trabajando para tí.+',
                  style: CustomStyles.styleMuggleGray_416x700,
                  textAlign: TextAlign.left,
                  //overflow: TextOverflow.clip,
                ),
                SelectableText.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Nuestros expertos están buscando los mejores precios e inventario de tus productos.',
                        style: CustomStyles.styleMuggleGray_414x400,),
                      TextSpan(text: "\nTiempo trasncurrido: 00:10:59",
                        style: CustomStyles.styleSafeBlue14x400,)
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            )
          ],
        )
    );
  }
}


class BacklogItemView extends StatefulWidget {
  BacklogItemView({Key? key, required this.i, required this.viewModel}) : super(key: key);
  int i;
  QuoteViewModel viewModel;

  @override
  _BacklogItemViewState createState() => _BacklogItemViewState();
}
class _BacklogItemViewState extends State<BacklogItemView>  {
  var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");
  TextEditingController textEditingController = TextEditingController();
  late PendingProduct product;
  @override
  void initState() {
    super.initState();
    product = widget.viewModel.quote.pendingProducts![widget.i -1];
  }

  _discardProduct() async {
    widget.viewModel.onDeleteSkuFromPending(product);
    widget.viewModel.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: _discardProduct,
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
