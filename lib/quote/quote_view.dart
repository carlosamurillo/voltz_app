
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maketplace/quote/quote_viewmodel.dart';
import 'package:maketplace/utils/style.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import '../utils/custom_colors.dart';


class QuoteView extends StatelessWidget {
  const QuoteView ({ Key? key, }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuoteViewModel>.reactive(
      viewModelBuilder: () => QuoteViewModel(),
      onModelReady: (viewModel) => viewModel.init(),
      fireOnModelReadyOnce: false,
      disposeViewModel: true,
      builder: (context, viewModel, child) {
        print ("paso por aqui xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
        if(viewModel.quote.detail == null){
          return const CircularProgressIndicator();
        } else {
          return Scaffold(
            backgroundColor: CustomColors.backgroundCanvas,
            body: Container(
              padding: EdgeInsets.all(0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _QuoteHeader(),
                          const Divider(
                            height: 1,
                            color: CustomColors.grayBackground,
                          ),
                          _QuoteHeaderId(),
                          const Divider(
                            height: 1,
                            color: CustomColors.grayBackground,
                          ),
                          const SizedBox(height: 24,),
                          if(viewModel.quote.detail != null) ...[
                            for(int i = 0; i <=
                                viewModel.quote.detail!.length - 1; i++) ...{
                              _QuoteTableDetail(i: i,),
                            },
                          ],
                          _QuoteTableNotInclude(),
                        ],
                      ),
                    ),
                  ),
                  _QuoteTotals(),
                ],
              ),
            ),
          );
        }
      }
    );
  }
}


class _QuoteHeader extends HookViewModelWidget<QuoteViewModel> {
  const _QuoteHeader({Key? key}) : super(key: key, reactive: false);

  @override
  Widget buildViewModelWidget(
      BuildContext context,
      QuoteViewModel model,
      ) {
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
                  onTap: (){

                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    alignment: Alignment.center,
                    child:  Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/pdf_export_ico.svg',
                          width: 16,
                          height: 20,
                        ),
                        const SizedBox(width: 8,),
                        RichText(
                          textAlign: TextAlign.start,
                          text: new TextSpan(
                            children: [
                              new TextSpan(text: 'Exportar PDF',
                                style: TextStyle(
                                  fontFamily: "Hellix",
                                  color: CustomColors.safeBlue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ),
          SizedBox(width: 16,),
          ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: BorderSide(color: CustomColors.energyYellow)
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(CustomColors.energyYellow),
                  padding:
                  MaterialStateProperty.all(const EdgeInsets.all(20)),
                  textStyle: MaterialStateProperty.all(
                      const TextStyle(fontSize: 14, color: Colors.white))),
              onPressed: () {

              },
              child: const Text('Hacer pedido  -  \$135,971.19 ', style: CustomStyles.styleBlackContrastUno,)
          ),
        ],
      ),
    );
  }
}

class _QuoteHeaderId extends HookViewModelWidget<QuoteViewModel> {
  const _QuoteHeaderId({Key? key}) : super(key: key, reactive: false);

  @override
  Widget buildViewModelWidget(
      BuildContext context,
      QuoteViewModel model,
      ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 26, horizontal: 64),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            textAlign: TextAlign.start,
            text: new TextSpan(
              children: [
                new TextSpan(text: 'Cotización',
                  style: TextStyle(
                    fontFamily: "Hellix",
                    color: CustomColors.volcanicBlue,
                    fontSize: 48,
                    fontWeight: FontWeight.w600,),
                ),
                new TextSpan(text: ' #',
                  style: TextStyle(
                    fontFamily: "Hellix",
                    color: CustomColors.volcanicBlue,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,),
                ),
              ],
            ),
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
                child: RichText(
                  textAlign: TextAlign.start,
                  text: new TextSpan(
                    children: [
                      new TextSpan(text: 'CLIENTE:',
                        style: TextStyle(
                          fontFamily: "Hellix",
                          color: CustomColors.volcanicBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,),
                      ),
                      new TextSpan(text: model.quote.alias,
                        style: TextStyle(
                          fontFamily: "Hellix",
                          color: CustomColors.volcanicBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,),
                      ),
                    ],
                  ),
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
                child: RichText(
                  textAlign: TextAlign.start,
                  text: new TextSpan(
                    children: [
                      new TextSpan(text: 'FECHA:',
                        style: TextStyle(
                          fontFamily: "Hellix",
                          color: CustomColors.volcanicBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,),
                      ),
                      new TextSpan(text: ' 31/07/2022',
                        style: TextStyle(
                          fontFamily: "Hellix",
                          color: CustomColors.volcanicBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,),
                      ),
                    ],
                  ),
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

                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                      alignment: Alignment.center,
                      child:  Row(
                        children: [
                          RichText(
                            textAlign: TextAlign.start,
                            text: new TextSpan(
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

class _QuoteTotals extends HookViewModelWidget<QuoteViewModel> {
  const _QuoteTotals({Key? key}) : super(key: key, reactive: false);

  @override
  Widget buildViewModelWidget(
      BuildContext context,
      QuoteViewModel model,
      ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft:Radius.circular(16), topRight: Radius.circular(16)),
        color: CustomColors.safeBlue,
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
                    Text(
                      "Subtotal único",
                      style: CustomStyles.styleWhiteUno,
                    ),
                    Spacer(),
                    Text(
                      model.quote.total.toString(),
                      style: CustomStyles.styleWhiteUno,
                    ),
                  ],
                ),
                const SizedBox(height: 8,),
                Row(
                  children: [
                    Text(
                      "Descuento",
                      style: CustomStyles.styleWhiteUno,
                    ),
                    Spacer(),
                    Text(
                      model.quote.discount.toString(),
                      style: CustomStyles.styleWhiteUno,
                    ),
                  ],
                ),
                const SizedBox(height: 8,),
                Row(
                  children: [
                    Text(
                      "IVA",
                      style: CustomStyles.styleWhiteUno,
                    ),
                    Spacer(),
                    Text(
                      model.quote.tax.toString(),
                      style: CustomStyles.styleWhiteUno,
                    ),
                  ],
                ),
              ],
            ),
          ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 64),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                                side: BorderSide(color: CustomColors.energyYellow)
                              ),
                            ),
                    backgroundColor: MaterialStateProperty.all(CustomColors.energyYellow),
                    padding:
                    MaterialStateProperty.all(const EdgeInsets.all(20)),
                    textStyle: MaterialStateProperty.all(
                            const TextStyle(fontSize: 14, color: Colors.white))),
                    onPressed: () {

                    },
                    child: Text('Hacer pedido  -  ${model.quote.total}' , style: CustomStyles.styleBlackContrastUno,)
                ),
              )
            ),
          )
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
          if(model.quote.discardedProducts != null) ...[
            for(int i = 0; i <= model.quote.discardedProducts!.length - 1 ; i++) ...{
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: i == 3 ? BorderRadius.only(bottomLeft:Radius.circular(16), bottomRight: Radius.circular(16)) : null,
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Text(
                      model.quote.discardedProducts![i].requestedProducts!,
                      style: CustomStyles.styleVolcanicUno,
                      textAlign: TextAlign.left,
                    ),
                    const Spacer(),
                    Text(
                      model.quote.discardedProducts![i].reason!,
                      style: CustomStyles.styleVolcanicUno,
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            }
          ]
        ],
      ),
    );
  }
}

class _QuoteTableDetail extends HookViewModelWidget<QuoteViewModel> {
  _QuoteTableDetail({Key? key, required this.i}) : super(key: key, reactive: true);
  int i = 0;

  @override
  Widget buildViewModelWidget(
      BuildContext context,
      QuoteViewModel model,
      ) {
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
    }
    return Container(
      padding: const EdgeInsets.only(left: 60, right: 60, top: 16, bottom: 16 ),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft:Radius.circular(16), topRight: Radius.circular(16)),
              color: CustomColors.safeBlue,
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
                  child: Text(
                    (i + 1).toString(),
                    style: CustomStyles.styleBlueUno,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Text( model.quote.detail![i].productRequested!,
                    style: CustomStyles.styleWhiteUno,
                  ),
                ),
                const Spacer(),
                IconButton(
                    icon: SvgPicture.asset(
                      'assets/svg/delete_icon.svg',
                      width: 64,
                      height: 64,
                    ),
                    onPressed: () {
                      print('clicked');
                    } //do something,
                ),
              ],
            ),
          ),
          for(int b = 0; b <= model.quote.detail![i].productsSuggested!.length -1; b++) ...{
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                borderRadius: b == 3 ? BorderRadius.only(bottomLeft:Radius.circular(16), bottomRight: Radius.circular(16)) : null,
                color: Colors.white,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: false,
                    onChanged: (bool? value) {

                    },
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.quote.detail![i].productsSuggested![b].sku!,
                        style: CustomStyles.styleVolcanicBlueUno,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        model.quote.detail![i].productsSuggested![b].skuDescription!.replaceAll("<em>", "").replaceAll("<\/em>", ""),
                        style: CustomStyles.styleVolcanicUno,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.clip,
                      ),
                    ],
                  ),
                  const Spacer(),
                  const SizedBox(
                    width: 30,
                  ),
                  Container(
                    width: 159,
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    child: Expanded(
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          Text( model.quote.detail![i].productsSuggested![b].brand!.replaceAll("<em>", "").replaceAll("<\/em>", ""),
                            style: CustomStyles.styleVolcanicBlueDos,
                            textAlign: TextAlign.left,
                          ),
                          Text( model.quote.detail![i].productsSuggested![b].subBrand!.replaceAll("<em>", "").replaceAll("<\/em>", ""),
                            style: CustomStyles.styleVolcanicBlueDos,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    )
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Container(
                          width: 90,
                          child: NumberInputWithIncrementDecrement(
                            controller: TextEditingController(),
                            onIncrement: (num newlyIncrementedValue) {
                              print('Newly incremented value is $newlyIncrementedValue');
                              model.onChangeDetailQuantity(i, b, newlyIncrementedValue.toInt());
                            },
                            onDecrement: (num newlyDecrementedValue) {
                              print('Newly decremented value is $newlyDecrementedValue');
                              model.onChangeDetailQuantity(i, b, newlyDecrementedValue.toInt());
                            },
                            numberFieldDecoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            widgetContainerDecoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Color(0xFFF9FAFF),
                              border: Border.all(
                                color: Color(0xFFE6E8F2),
                                width: 1.6,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 2), // changes position of shadow
                                ),
                              ],
                            ),
                            separateIcons: true,
                            decIconDecoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                              ),
                            ),
                            incIconDecoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            incDecBgColor: Colors.transparent,
                            incIcon: Icons.expand_less,
                            decIcon: Icons.expand_more,
                            decIconColor: CustomColors.volcanicBlue,
                            incIconColor: CustomColors.volcanicBlue,
                            decIconSize: 16,
                            incIconSize: 16,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          model.quote.detail![i].productsSuggested![b].saleUnit!,
                          style: CustomStyles.styleVolcanicUno,
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(24),
                    width: 177,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          (model.quote.detail![i].productsSuggested![b].salePrice! * model.quote.detail![i].productsSuggested![b].quantity!).toString(),
                          style: CustomStyles.styleVolcanicBlueTres,
                          textAlign: TextAlign.right,
                        ),
                        Text(
                          model.quote.detail![i].productsSuggested![b].salePrice!.toString(),
                          style: CustomStyles.styleVolcanicUno,
                          textAlign: TextAlign.right,
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
    );
  }
}