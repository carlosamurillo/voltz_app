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


class DiscardView extends StatefulWidget {
  const DiscardView({Key? key, required this.viewModel}) : super(key: key);
  final QuoteViewModel viewModel;
  @override
  _DiscardViewState createState() => _DiscardViewState();
}

class _DiscardViewState extends State<DiscardView> {

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  _handleRefresh() async{

  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () => _handleRefresh(),
        child:
        Builder(
          builder: (BuildContext context) {
            if (widget.viewModel.quote.discardedProducts != null) {
              return
                Container(
                  color: Colors.white,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                    reverse: false,
                    controller: widget.viewModel.scrollController,
                    itemCount: widget.viewModel.quote.discardedProducts!.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return NoIncludeSign();
                      } else {
                        return _BacklogItemView(viewModel: widget.viewModel, i: index,);
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
        )
    );
  }
}

class NoIncludeSign extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 30, bottom: 30),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: const Color(0xFFF4493E).withOpacity(0.15),
        ),
        width: double.infinity,
        child: Row(
          children: [
            SelectableText(
              'Estos productos no se incluirán en tu cotización',
              style: CustomStyles.styleMuggleGray_416x700,
              textAlign: TextAlign.left,
              //overflow: TextOverflow.clip,
            ),
          ],
        )
    );
  }
}


class _BacklogItemView extends StatefulWidget {
  _BacklogItemView({Key? key, required this.i, required this.viewModel}) : super(key: key);
  int i;
  QuoteViewModel viewModel;

  @override
  _BacklogItemViewState createState() => _BacklogItemViewState();
}
class _BacklogItemViewState extends State<_BacklogItemView>  {
  var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");
  TextEditingController textEditingController = TextEditingController();
  late DiscardedProducts product;
  @override
  void initState() {
    super.initState();
    product = widget.viewModel.quote.discardedProducts![widget.i -1];
  }

  _discardProduct() async {

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
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child:SelectableText.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: product.requestedProducts!.replaceAll("<em>", "").replaceAll("<\/em>", ""),
                        style: CustomStyles.styleMuggleGray_414x400,),
                      TextSpan(text: "\n${product.reason}",
                        style: CustomStyles.styleRedAlert16x400,)
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            )
          ],
        )
    );
  }
}
