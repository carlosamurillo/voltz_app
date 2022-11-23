
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart' as intl;
import 'package:maketplace/cart/tabs_view.dart';
import 'package:maketplace/quote/quote_viewmodel.dart';
import 'package:maketplace/utils/style.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import '../common/header.dart';
import '../utils/custom_colors.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../utils/shimmer.dart';

class CartView extends StatefulWidget {
  const CartView({Key? key, required this.quoteId, required this.version}) : super(key: key);
  final String quoteId;
  final String? version;

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  late QuoteViewModel model;
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuoteViewModel>.nonReactive(
      viewModelBuilder: () => QuoteViewModel(),
      builder: (context, viewModel, child) {
        return Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              padding: EdgeInsets.all(0),
              child: Column(
                children: [
                  Header(),
                  _Container(),
                ],
              ),
            )
        );
      },
      onModelReady: (viewModel) => viewModel.init(widget.quoteId, widget.version),
      fireOnModelReadyOnce: true,
    );
  }

}

class _Container extends StatelessWidget {

  @override
  Widget build(
      BuildContext context,
      ) {
    return Expanded(
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: CustomColors.muggleGray, width: 1),
            color: Colors.white,
          ),
          margin: const EdgeInsets.only(bottom: 0, top: 30, left: 90, right: 90),
          width: double.infinity,
          child: Column(
            children: [
              Expanded(child: _CartContent(),),
              // Spacer(),
              _CartTotals(),
            ],
          ),
      ),
    );
  }
}

class _CartContent extends StatefulWidget {

  @override
  _CartContentState createState() => _CartContentState();
}
class _CartContentState extends State<_CartContent> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _initTabController();
  }

  _initTabController() async {
    _initTabControllerForPrincipalMenu();
  }

  _initTabControllerForPrincipalMenu() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return  Container(

      //padding: EdgeInsets.only(top: 20, left: 30, right: 30),
      margin: EdgeInsets.only(top: 20, left: 50, right: 50),
      child: Column(
        children: [
          Tabs(tabController: _tabController,),
          Expanded(child: TabsContent(tabController: _tabController,), ),
        ],
      ),
    );
  }
}

class ComebackLater extends StatelessWidget {
  const ComebackLater({required this.totalProducts });
  final int totalProducts;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        color: const Color(0xFFFBE597).withOpacity(0.5),
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
                totalProducts.toString() + ' productos en proceso de cotización...',
                style: CustomStyles.styleMuggleGray_416x700,
                textAlign: TextAlign.left,
                //overflow: TextOverflow.clip,
              ),
              SelectableText.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Estamos trabajando para encontrarte la mejor opción, en cientos de proveedores. \nIrán apareciendo arriba en la lista.',
                      style: CustomStyles.styleMuggleGray_414x400,),
                    TextSpan(text: " ¡Regresa pronto!",
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

class _CartTotals extends HookViewModelWidget<QuoteViewModel> {
  _CartTotals({Key? key,}) : super(key: key, reactive: true);
  var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

  @override
  Widget buildViewModelWidget(
      BuildContext context,
      QuoteViewModel model,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10.0,
            spreadRadius: 2.0,
            offset: Offset(0, -3),
          ),
        ],
      ),
      //height: 104,
      width: double.infinity,
      padding: EdgeInsets.all(30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Spacer(),
          _labelSubTotales(currencyFormat: currencyFormat,),
          SizedBox(width: 40,),
          Container(
            width: 189,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6),),
                color: CustomColors.safeBlue,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  hoverColor: CustomColors.safeBlueHover,
                  onTap: () async {
                    return model.navigateToQuoteConfirmation();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    alignment: Alignment.center,
                    child:  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text('Generar cotización', textAlign: TextAlign.center , style: CustomStyles.styleWhite16x600,),
                      ],
                    ),
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }
}

class _labelSubTotales extends HookViewModelWidget<QuoteViewModel> {
  _labelSubTotales({Key? key, required this.currencyFormat}) : super(key: key, reactive: true);
  var currencyFormat;

  @override
  Widget buildViewModelWidget(
      BuildContext context,
      QuoteViewModel model,
      ) {
    return
      Shimmer(
        linearGradient: model.shimmerGradient,
        child: ShimmerLoading(
          isLoading: model.isLoading,
          shimmerEmptyBox: const ShimmerEmptyBox(width: 500, height: 21,),
          child: model.isLoading ? Container() :
          SelectableText.rich(TextSpan(
            children: [
              TextSpan(text: 'Subtotal',
                style: CustomStyles.styleMuggleGray_416x400,),
              TextSpan(text: " ${currencyFormat.format(model.quote.totals!.subTotal)}",
                style: CustomStyles.styleMuggleGray_416x600,),
              TextSpan(text: '    Dcto. adicional',
                style: CustomStyles.styleMuggleGray_416x400,),
              TextSpan(text: " ${currencyFormat.format(model.quote.totals!.discount!)}",
                style: CustomStyles.styleEnergyYellow_416x600,),
              TextSpan(text: '    Total',
                style: CustomStyles.styleMuggleGray_416x400,),
              TextSpan(text: " ${currencyFormat.format(model.quote.totals!.subTotal! - model.quote.totals!.discount!)}",
                style: CustomStyles.styleMuggleGray_416x600,),
            ],
          ),
            textAlign: TextAlign.left,
          ),
        ),
      );
  }
}