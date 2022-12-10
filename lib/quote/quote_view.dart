
import 'dart:html' as html;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:maketplace/quote/quote_view_mobile.dart';
import 'package:maketplace/quote/quote_viewmodel.dart';
import 'package:maketplace/utils/style.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import '../utils/custom_colors.dart';
import 'package:intl/date_symbol_data_local.dart';

class QuoteView extends StatefulWidget {
  const QuoteView({Key? key, required this.quoteId, required this.version}) : super(key: key);
  final String quoteId;
  final String? version;

  @override
  _QuoteViewState createState() => _QuoteViewState();
}

class _QuoteViewState extends State<QuoteView> {
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
        if(viewModel.quote.detail == null){
          return const Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          html.window.history.pushState(null, 'Voltz - Cotización ${model.quote.consecutive}', '?cotz=${model.quote.id!}');
          return Scaffold(
            backgroundColor: CustomColors.backgroundCanvas,
            body: MediaQuery.of(context).size.width >= 480 ? Container(
              padding: EdgeInsets.all(0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          _QuoteHeader(total: viewModel.quote.totals!.total!, onAcceptQuote: _acceptQuote, id: viewModel.quote.id!),
                          const Divider(
                            height: 1,
                            color: CustomColors.grayBackground,
                          ),
                          _QuoteHeaderId(listener: _scrollDown,),
                          const Divider(
                            height: 1,
                            color: CustomColors.grayBackground,
                          ),
                          const SizedBox(height: 24,),
                          if(viewModel.quote.detail != null) ...[
                            for(int i = 0; i <=
                                viewModel.quote.detail!.length - 1; i++) ...{
                              _QuoteTableDetail(i: i, listener: _updateTotals,),
                            },
                          ],
                          _QuoteTableNotInclude(),
                        ],
                      ),
                    ),
                  ),
                  if(viewModel.version != 'original') ...[
                    _QuoteTotals(tax: viewModel.quote.totals!.tax!, total: viewModel.quote.totals!.total!,
                      subTotal: viewModel.quote.totals!.subTotal!, shippingTotal: (viewModel.quote.shipping != null ? viewModel.quote.shipping!.total! : null) , isSaveActive: viewModel.isSaveActive,
                      quoteId: viewModel.quote.id!,
                      onAcceptQuote: _acceptQuote,),
                  ],
                ],
              ),
            )
                : // Version Mobile ***************** Version Mobile
            Container(
              padding: EdgeInsets.all(0),
              child: Column(
                children: [
                  QuoteHeaderMobile(total: viewModel.quote.totals!.total!, onAcceptQuote: _acceptQuote, consecutive: viewModel.quote.consecutive.toString(), quoteId: viewModel.quote.id! ),
                  const Divider(
                    height: 1,
                    color: CustomColors.grayBackground,
                  ),
                  if(viewModel.version != 'original') ...[
                    QuoteTotalsMobile(tax: viewModel.quote.totals!.tax!, total: viewModel.quote.totals!.total!,
                      subTotal: viewModel.quote.totals!.subTotal!, discount: viewModel.quote.totals!.discount!, isSaveActive: viewModel.isSaveActive,
                      quoteId: viewModel.quote.id!,
                      onAcceptQuote: _acceptQuote, totalProducts: viewModel.quote.detail!.length,
                    ),
                  ],
                  const SizedBox(height: 16,),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          if(viewModel.quote.detail != null) ...[
                            for(int i = 0; i <=
                                viewModel.quote.detail!.length - 1; i++) ...{
                              QuoteTableDetailMobile(i: i, listener: _updateTotals,),
                            },
                          ],
                          const QuoteMobileTableNotInclude(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
    );
  }

  _scrollDown(){
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  void _updateTotals() async {
    if (mounted) {
      setState(() {
      });
    }
  }

  _acceptQuote() async {
    model.onGenerateOrder(context);
  }
}


class _QuoteHeader extends StatelessWidget {
   _QuoteHeader({required this.total, required this.onAcceptQuote, required this.id});
  double total;
  String id;
  var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");
  final VoidCallback onAcceptQuote;

  @override
  Widget build(BuildContext context) {
    final _url = 'https://us-central1-voltz-pro.cloudfunctions.net/exportToExcel-createCsv/${id}';
    return Container(
      padding: EdgeInsets.symmetric(vertical: 26, horizontal: 64),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/svg/voltz_logo.svg',
            width: 122,
            height: 24.5,
          ),
          const Spacer(),
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(26),),
                  color: Color(0xFFFFFDFB),
                  border: Border.all(width: 2, color: CustomColors.safeBlue)
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(26)),
                  hoverColor: CustomColors.blueBackground,
                  onTap: () async {
                    html.window.open(_url, "_blank");
                    context.read<QuoteViewModel>().trackCSVExport();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    alignment: Alignment.center,
                    child:  Row(
                      children: [
                        /*SvgPicture.asset(
                          'assets/svg/pdf_export_ico.svg',
                          width: 16,
                          height: 20,
                        ),
                        const SizedBox(width: 8,),*/
                        RichText(
                          text: TextSpan(
                            children: [
                              new TextSpan(text: 'Exportar CSV',
                                style: TextStyle(
                                  fontFamily: "Hellix",
                                  color: CustomColors.safeBlue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ),
          SizedBox(width: 16,),
          if(context.read<QuoteViewModel>().version != 'original') ...[
            Container(
                width: 300,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(26),),
                  color: CustomColors.safeBlue,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(26)),
                    hoverColor: CustomColors.safeBlueHover,
                    onTap: (){
                      _Dialogs dialog = _Dialogs();
                      dialog.showAlertDialog(context, onAcceptQuote, context.read<QuoteViewModel>().createConfirmMessage(), context.read<QuoteViewModel>().quote.id!);
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
                          Text('Hacer pedido  -  ${currencyFormat.format(total)}' , style: CustomStyles.styleWhiteDos,)
                        ],
                      ),
                    ),
                  ),
                )
            ),
          ],
        ],
      ),
    );
  }
}

class _QuoteHeaderId extends HookViewModelWidget<QuoteViewModel> {
  _QuoteHeaderId({Key? key, required this.listener}) : super(key: key, reactive: false);
  final VoidCallback listener;

  @override
  Widget buildViewModelWidget(
      BuildContext context,
      QuoteViewModel model,
      ) {
    final f = intl.DateFormat('MMMM dd, yyyy hh:mm', 'es_MX');
    String formattedDate = f.format(model.quote.createdAt!.toDate().toLocal()) ;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 26, horizontal: 64),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText.rich(
            TextSpan(
              children: [
                new TextSpan(text: 'Cotización ',
                  style: TextStyle(
                    fontFamily: "Hellix",
                    color: CustomColors.volcanicBlue,
                    fontSize: 48,
                    fontWeight: FontWeight.w600,),
                ),
                new TextSpan(text: "#${model.quote.consecutive.toString()}",
                  style: TextStyle(
                    fontFamily: "Hellix",
                    color: CustomColors.volcanicBlue,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,),
                ),
              ],
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 24,),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10),),
                  color: Color(0xFFF9FAFF),
                  border: Border.all(width: 1, color: Color(0xFFE5E7EB))
                ),
                child: SelectableText.rich(
                  TextSpan(
                    children: [
                      /*new TextSpan(text: 'CLIENTE: ',
                        style: TextStyle(
                          fontFamily: "Hellix",
                          color: CustomColors.volcanicBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,),
                      ),*/
                      new TextSpan(text: model.quote.alias,
                        style: TextStyle(
                          fontFamily: "Hellix",
                          color: CustomColors.volcanicBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(width: 40,),
              Container(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10),),
                    color: Color(0xFFF9FAFF),
                    border: Border.all(width: 1, color: Color(0xFFE5E7EB))
                ),
                child: SelectableText.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: 'FECHA: ',
                        style: TextStyle(
                          fontFamily: "Hellix",
                          color: CustomColors.volcanicBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,),
                      ),
                      TextSpan(text: formattedDate,
                        style: const TextStyle(
                          fontFamily: "Hellix",
                          color: CustomColors.volcanicBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(26),),
                    color: Color(0xFFFFFDFB),
                    border: Border.all(width: 2, color: CustomColors.orangeAlert)
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(26)),
                    hoverColor: CustomColors.energyYellow_20,
                    onTap: (){
                      listener();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                      alignment: Alignment.center,
                      child:  Row(
                        children: [
                          SelectableText.rich(
                            TextSpan(
                              children: [
                                new TextSpan(text: model.quote.discardedProducts!.length.toString() + ' Productos no incluidos',
                                  style: TextStyle(
                                    fontFamily: "Hellix",
                                    color: CustomColors.orangeAlert,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(width: 8,),
                          SvgPicture.asset(
                            'assets/svg/arrow_down.svg',
                            width: 13.5,
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ),
            ],
          )
        ],
      ),
    );
  }
}


class _QuoteTotals extends StatefulWidget {
  const _QuoteTotals({Key? key, required this.tax, required this.total, required this.subTotal,
    required this.shippingTotal, this.isSaveActive = false, required this.quoteId, required this.onAcceptQuote}) : super(key: key, );
  final double tax;
  final double total;
  final double subTotal;
  final double? shippingTotal;
  final bool isSaveActive;
  final String quoteId;
  final VoidCallback onAcceptQuote;

  @override
  _QuoteTotalsState createState() => _QuoteTotalsState();
}

class _QuoteTotalsState extends State<_QuoteTotals> {
  var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft:Radius.circular(16), topRight: Radius.circular(16)),
        color: CustomColors.volcanicBlue,
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Column(
              children: [
                Row(
                  children: [
                    SelectableText(
                      "Subtotal único",
                      style: CustomStyles.styleWhiteUno,
                    ),
                    Spacer(),
                    SelectableText(
                      currencyFormat.format(widget.subTotal),
                      style: CustomStyles.styleWhiteUno,
                    ),
                  ],
                ),
                const SizedBox(height: 8,),
                Row(
                  children: [
                    SelectableText(
                      "IVA",
                      style: CustomStyles.styleWhiteUno,
                    ),
                    Spacer(),
                    SelectableText(
                      currencyFormat.format(widget.tax * widget.subTotal),
                      style: CustomStyles.styleWhiteUno,
                    ),
                  ],
                ),
                if(widget.shippingTotal != null) ...[
                  const SizedBox(height: 8,),
                  Row(
                    children: [
                      SelectableText(
                        "Costo de envío",
                        style: CustomStyles.styleWhiteUno,
                      ),
                      Spacer(),
                      SelectableText(
                        currencyFormat.format(widget.shippingTotal),
                        style: CustomStyles.styleWhiteUno,
                      ),
                    ],
                  ),
                ],
                if(context.read<QuoteViewModel>().version == 'original') ...[
                  const SizedBox(height: 8,),
                  Row(
                    children: [
                      SelectableText(
                        "Total",
                        style: CustomStyles.styleWhiteUno,
                      ),
                      Spacer(),
                      SelectableText(
                        currencyFormat.format(widget.total),
                        style: CustomStyles.styleWhiteUno,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          ),
          if(context.read<QuoteViewModel>().version != 'original') ...[
            Expanded(
              child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 64),
                  child: Column(
                    children: [
                      Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(26),),
                            color: CustomColors.safeBlue,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: const BorderRadius.all(Radius.circular(26)),
                              hoverColor: CustomColors.safeBlueHover,
                              onTap: (){
                                _Dialogs dialog = _Dialogs();
                                dialog.showAlertDialog(context, widget.onAcceptQuote, context.read<QuoteViewModel>().createConfirmMessage(), widget.quoteId);
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
                                    Text('Hacer pedido  -  ${currencyFormat.format(widget.total)}' , style: CustomStyles.styleWhiteDos,)
                                  ],
                                ),
                              ),
                            ),
                          )
                      ),
                    ],
                  )
              ),
            )
          ],
        ],
      ),
    );
  }


}

class _QuoteTableNotInclude extends HookViewModelWidget<QuoteViewModel> {
  const _QuoteTableNotInclude({Key? key}) : super(key: key, reactive: false);

  @override
  Widget buildViewModelWidget(
      BuildContext context,
      QuoteViewModel model,
      ) {
    return Container(
      padding: const EdgeInsets.only(left: 60, right: 60, top: 16, bottom: 40 ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft:Radius.circular(16), topRight: Radius.circular(16)),
                color: CustomColors.redAlert,
              ),
              child: Row(
                children: [
                  Text(
                    "PRODUCTOS NO INCLUIDOS EN TU COTIZACIÓN",
                    style: CustomStyles.styleWhiteUno,
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              height: 20,
            ),
            if(model.quote.discardedProducts != null) ...[
              for(int i = 0; i <= model.quote.discardedProducts!.length - 1 ; i++) ...{
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  decoration: BoxDecoration(
                    borderRadius: i == 3 ? BorderRadius.only(bottomLeft:Radius.circular(16), bottomRight: Radius.circular(16)) : null,
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: SelectableText(
                          model.quote.discardedProducts![i].requestedProducts!.toUpperCase(),
                          style: CustomStyles.styleVolcanicUno,
                          textAlign: TextAlign.left,
                          //overflow: TextOverflow.clip,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SelectableText(
                          model.quote.discardedProducts![i].reason!,
                          style: CustomStyles.styleVolcanicUno,
                          textAlign: TextAlign.right,
                          //overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                ),
              }
            ],
            Container(
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft:Radius.circular(16), bottomRight: Radius.circular(16)),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _QuoteTableDetail extends StatefulWidget {
  _QuoteTableDetail({Key? key, required this.i, required this.listener}) : super(key: key);
  int i;
  final VoidCallback listener;

  @override
  _QuoteTableDetailState createState() => _QuoteTableDetailState();
}

class _QuoteTableDetailState extends State<_QuoteTableDetail> {
  late QuoteViewModel model;
  var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");

  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    model = context.read<QuoteViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return CustomColors.energyYellow;
      }
      return CustomColors.safeBlue;
    };
    Color headerColor = CustomColors.volcanicBlue;
    for(int b = 0; b <= model.quote.detail![widget.i].productsSuggested!.length -1; b++) {
      if (model.quote.detail![widget.i].productsSuggested![b].selected == true) {
        headerColor =  CustomColors.safeBlue;
        break;
      } else {
        headerColor = CustomColors.volcanicBlue;
      }
    }

    return Container(
      padding: const EdgeInsets.only(left: 60, right: 60, top: 16, bottom: 16 ),
      child:  Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft:Radius.circular(16), topRight: Radius.circular(16)),
                color: headerColor,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: CustomColors.energyYellow,
                    ),
                    alignment: Alignment.center,
                    width: 56,
                    child: SelectableText(
                      model.quote.detail![widget.i].position!.toString(),
                      style: CustomStyles.styleBlueUno,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child:Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: SelectableText( model.quote.detail![widget.i].productRequested!.toUpperCase(),
                        style: CustomStyles.styleWhiteUno, //overflow: TextOverflow.clip,
                      ),
                    ),
                  ),
                  if(context.read<QuoteViewModel>().version != 'original') ...[
                    IconButton(
                        icon: SvgPicture.asset(
                          'assets/svg/delete_icon.svg',
                          width: 64,
                          height: 64,
                        ),
                        onPressed: () async {
                          model.onDeleteSku(model.quote.detail![widget.i]);
                          _updateTotals();
                        } //do something,
                    ),
                  ],
                ],
              ),
            ),
            for(int b = 0; b <= model.quote.detail![widget.i].productsSuggested!.length -1; b++) ...{
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: b == model.quote.detail![widget.i].productsSuggested!.length -1 ? BorderRadius.only(bottomLeft:Radius.circular(16), bottomRight: Radius.circular(16)) : null,
                  color: model.quote.detail![widget.i].productsSuggested![b].selected == false ? Colors.white : CustomColors.blueBackground,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 140,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 24,
                            child: context.read<QuoteViewModel>().version != 'original' ? Checkbox(
                              checkColor: Colors.white,
                              fillColor: MaterialStateProperty.resolveWith(getColor),
                              value: model.quote.detail![widget.i].productsSuggested![b].selected,
                              onChanged: (bool? value) async {
                                return setState(() async {
                                  await model.onSelectedSku(value!, widget.i, b);
                                  _updateTotals();
                                });
                              },
                            ) : Container(),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          if(1==1) ...{
                            SvgPicture.asset(
                              'assets/svg/no_image_ico.svg',
                              width: 56,
                              height: 56,
                            ),
                          },
                          const SizedBox(
                            width: 30,
                          ),
                        ],
                      ) ,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText(
                            model.quote.detail![widget.i].productsSuggested![b].sku!,
                            style: CustomStyles.styleVolcanicBlueUno,
                            textAlign: TextAlign.left,
                          ),
                          SelectableText(
                            model.quote.detail![widget.i].productsSuggested![b].skuDescription!.replaceAll("<em>", "").replaceAll("<\/em>", ""),
                            style: CustomStyles.styleVolcanicUno,
                            textAlign: TextAlign.left,
                            //overflow: TextOverflow.clip,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 524,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          Container(
                            width: 159,
                            padding: const EdgeInsets.all(8),
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:  [
                                      SelectableText( model.quote.detail![widget.i].productsSuggested![b].brand!.replaceAll("<em>", "").replaceAll("<\/em>", ""),
                                        style: CustomStyles.styleVolcanicBlueDos,
                                        textAlign: TextAlign.left,
                                        //overflow: TextOverflow.clip,
                                      ),
                                      if (model.quote.detail![widget.i].productsSuggested![b].subBrand != null ) ...[
                                        SelectableText(  model.quote.detail![widget.i].productsSuggested![b].subBrand!.replaceAll("<em>", "").replaceAll("<\/em>", ""),
                                          style: CustomStyles.styleVolcanicBlueDos,
                                          textAlign: TextAlign.left,
                                          //overflow: TextOverflow.clip,
                                        ),
                                      ]
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: 158,
                            child: Row(
                              children: [
                                _QuantityWidget(i: widget.i, b: b, listenerUpdateTotals: _updateTotals),
                                const SizedBox(
                                  width: 8,
                                ),
                                SelectableText(
                                  model.quote.detail![widget.i].productsSuggested![b].saleUnit!,
                                  style: CustomStyles.styleVolcanicUno,
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(24),
                            width: 177,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SelectableText(
                                        (currencyFormat.format(model.quote.detail![widget.i].productsSuggested![b].pricePublic! * model.quote.detail![widget.i].productsSuggested![b].quantity!)),
                                        style: CustomStyles.styleVolcanicBlueTres,
                                        textAlign: TextAlign.right,
                                      ),
                                      SelectableText(
                                        "${currencyFormat.format(model.quote.detail![widget.i].productsSuggested![b].pricePublic!)} c/u",
                                        style: CustomStyles.styleVolcanicUno,
                                        textAlign: TextAlign.right,
                                      ),
                                    ],
                                  ),
                                ]
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            }
          ],
        ),
      )
    );
  }

  _updateTotals() async {
    if (mounted) {
      model.calculateTotals();
      widget.listener();
    }
  }

}


class _QuantityWidget extends StatefulWidget {
  const _QuantityWidget({Key? key, required this.i, required this.b, required this.listenerUpdateTotals}) : super(key: key);
  final int i; final int b;
  final VoidCallback listenerUpdateTotals;

  @override
  _QuantityWidgetState createState() => _QuantityWidgetState();
}

class _QuantityWidgetState extends State<_QuantityWidget> {
  var currencyFormat = intl.NumberFormat.currency(locale: "es_MX", symbol: "\$");
  late QuoteViewModel _model;

  TextEditingController textEditingController = TextEditingController();
  bool indicator = false;

  @override
  void initState() {
    super.initState();
    _model = context.read<QuoteViewModel>();
    textEditingController.text = _model.quote.detail![widget.i].productsSuggested![widget.b].quantity!.toString();
    textEditingController.addListener(() {
      if(indicator == true) {
        _model.onUpdateQuote(widget.i, widget.b, double.parse(textEditingController.text),);
        widget.listenerUpdateTotals();
      }
      indicator = true;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(8),
      width: 90,
      child: context.read<QuoteViewModel>().version != 'original' ?  TextField(
        style: CustomStyles.styleMobileVolcanic15x600,
        controller: textEditingController,
        textAlign: TextAlign.center,
        onChanged: (value) {
          _model.onUpdateQuote(widget.i, widget.b, double.parse(textEditingController.text),);
        },

      ) : SelectableText(
        _model.quote.detail![widget.i].productsSuggested![widget.b].quantity.toString(),
        style:  CustomStyles.styleMobileVolcanic400,
        textAlign: TextAlign.left,
      ),
    );
  }
}

class _Dialogs {

  showAlertDialog(BuildContext context, VoidCallback onConfirm, String message, String quoteId) {
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const SelectableText("Hacer pedido"),
          titleTextStyle:
          TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,fontSize: 20),
          actionsOverflowButtonSpacing: 20,
          actions: [
            ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: const Text("Cancelar")
            ),
            ElevatedButton(
                onPressed: () async {
                  onConfirm();
                  Navigator.of(context).pop();
                },
                child: const Text("Confirmar")),
          ],
          content: SelectableText(message),
        );
      },
    );
  }
}

