import 'dart:html' as html;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:maketplace/cart/tabs_view.dart';
import 'package:maketplace/quote/quote_view_mobile.dart';
import 'package:maketplace/quote/quote_viewmodel.dart';
import 'package:maketplace/utils/style.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import '../utils/custom_colors.dart';
import 'package:intl/date_symbol_data_local.dart';


class CartView extends StatefulWidget {
  const CartView({Key? key, required this.quoteId, required this.version}) : super(key: key);
  final String quoteId;
  final String? version;

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  ScrollController _scrollController = ScrollController();
  late QuoteViewModel model;
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuoteViewModel>.reactive(
        viewModelBuilder: () => QuoteViewModel(),
        onModelReady: (viewModel) => viewModel.init(widget.quoteId, widget.version),
        fireOnModelReadyOnce: false,
        disposeViewModel: false,
        builder: (context, viewModel, child) {
          model = context.read<QuoteViewModel>();
          model.listenerUpdateTotals = _updateTotals;
          if(viewModel.quote.detail == null){
            return const Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            html.window.history.pushState(null, 'Voltz - Cotización ${viewModel.quote.consecutive}', '?cotz=${viewModel.quote.id!}');
            return Scaffold(
                backgroundColor: Colors.white,
                body: Container(
                  padding: EdgeInsets.all(0),
                  child: Column(
                    children: [
                      _Header(),
                      _Container(viewModel: viewModel,),
                    ],
                  ),
                )
            );
          }
        }
    );
  }

  void _updateTotals() async {
    if (mounted) {
      setState(() {
      });
    }
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
      color: CustomColors.superVolcanic,
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/svg/voltz_logo.svg',
            width: 122,
            height: 24.5,
          ),
          const Spacer(),
          SvgPicture.asset(
            'assets/svg/help_button.svg',
            width: 74,
            height: 39,
          ),
        ],
      ),
    );
  }
}

class _Container extends StatefulWidget {
  _Container({required this.viewModel,});
  QuoteViewModel viewModel;

  @override
  _ContainerState createState() => _ContainerState();
}
class _ContainerState extends State<_Container> {

  @override
  Widget build(BuildContext context) {
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
              Expanded(child: _CartContent(viewModel: widget.viewModel,),),
              // Spacer(),
              _CartTotals(),
            ],
          ),
      ),
    );
  }
}

class _CartContent extends StatefulWidget {
  _CartContent({required this.viewModel,});
  QuoteViewModel viewModel;

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
    _tabController = new TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return  Container(

      //padding: EdgeInsets.only(top: 20, left: 30, right: 30),
      margin: EdgeInsets.only(top: 20, left: 50, right: 50),
      child: Column(
        children: [
          Tabs(tabController: _tabController, viewModel : widget.viewModel),
          Expanded(child: TabsContent(tabController: _tabController, viewModel : widget.viewModel), ),
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

class _CartTotals extends StatefulWidget {
  const _CartTotals();
  @override
  _CartTotalsState createState() => _CartTotalsState();
}
class _CartTotalsState extends State<_CartTotals> {
  var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");
  late QuoteViewModel model;

  @override
  void initState() {
    super.initState();
    model = context.read<QuoteViewModel>();
  }

  @override
  Widget build(BuildContext context) {
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
          Expanded(
            child: Container(
                width: 300,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6),),
                  color: CustomColors.safeBlue,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    hoverColor: CustomColors.safeBlueHover,
                    onTap: (){

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
                          Text('Hacer pedido  -  ${currencyFormat.format(model.quote.total)}', textAlign: TextAlign.center , style: CustomStyles.styleWhite16x600,)
                        ],
                      ),
                    ),
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }
}