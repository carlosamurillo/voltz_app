import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maketplace/cart/buy_now_viewmodel.dart';
import 'package:maketplace/common/app_bar_view.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/product/product_views.dart';
import 'package:maketplace/utils/inputText.dart';
import 'package:maketplace/utils/style.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class BuyNowView extends StatelessWidget {
  const BuyNowView({
    Key? key,
    required this.productId,
  }) : super(key: key);
  final String productId;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ToBuyNowViewModel>.reactive(
        viewModelBuilder: () => ToBuyNowViewModel(),
        onViewModelReady: (viewModel) => viewModel.init(productId),
        fireOnViewModelReadyOnce: true,
        disposeViewModel: true,
        createNewViewModelOnInsert: true,
        builder: (context, viewModel, child) {
          if (kDebugMode) {
            print("ProductDetail ... Se actualiza la vista ...");
          }
          var media = MediaQuery.of(context).size;
          return Scaffold(
              backgroundColor: AppKeys().customColors!.blueVoltz,
              appBar: BlueAppBar(
                context: context,
                isMobile: media.width < CustomStyles.mobileBreak ? true : false,
              ),
              body: Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (viewModel.product != null) ...[
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppKeys().customColors!.white,
                                    borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                                    border: Border.all(color: const Color(0xFFD9E0FC), width: 1, style: BorderStyle.none),
                                  ),
                                  child: SizedBox(
                                    width: 362,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ProductCard(
                                          product: viewModel.product!,
                                          isCartVersion: true,
                                          isSearchVersion: false,
                                          removeActionsViewSection: true,
                                          calculatorFromUniqueProductWidget: const _QuantityCalculatorWidget(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (media.width >= CustomStyles.mobileBreak) ...[
                                  const Resume(),
                                ]
                              ] else ...[
                                Container(
                                    padding: const EdgeInsets.all(25.0),
                                    decoration: BoxDecoration(
                                      color: AppKeys().customColors!.blueVoltz,
                                    ),
                                    child: Center(
                                      child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: CircularProgressIndicator(
                                          color: AppKeys().customColors!.white,
                                        ),
                                      ),
                                    )),
                              ],
                            ],
                          ),
                          if (media.width < CustomStyles.mobileBreak && viewModel.product != null) ...[
                            SizedBox(height: media.height * 0.28),
                          ]
                        ],
                      ),
                    ),
                  ),
                  if (media.width < CustomStyles.mobileBreak && viewModel.product != null) ...[
                    const _BottomExpandedAppBar(),
                    const Positioned(bottom: 0, child: _BottomReminderTakeOrder()),
                  ]
                ],
              ));
        });
  }
}

class _BottomExpandedAppBar extends StatelessWidget {
  const _BottomExpandedAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.28,
      minChildSize: 0.28,
      maxChildSize: 0.8,
      controller: DraggableScrollableController(),
      builder: (context, scrollControllerBottom) {
        return ColoredBox(
          color: AppKeys().customColors!.sidebarColor,
          // color: CustomColors.redAlert,
          child: ResumeBottom(scrollControllerBottom: scrollControllerBottom),
        );
      },
    );
  }
}

class _BottomReminderTakeOrder extends StackedHookView<ToBuyNowViewModel> {
  const _BottomReminderTakeOrder({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ToBuyNowViewModel model,
  ) {
    return Builder(
      builder: (BuildContext context) {
        var media = MediaQuery.of(context).size;
        return Container(
          color: AppKeys().customColors!.sidebarColor,
          width: media.width,
          height: media.height * 0.20,
          child: SingleChildScrollView(
            controller: ScrollController(),
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 310,
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SelectableText(
                                  '${model.currencyFormat.format(model.totalCalculateValue)} MXN',
                                  style: GoogleFonts.inter(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.0,
                                    color: AppKeys().customColors!.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'total',
                                  style: GoogleFonts.inter(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0,
                                    color: AppKeys().customColors!.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                    width: 250,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(200),
                                      ),
                                      color: AppKeys().customColors!.energyColor,
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: const BorderRadius.all(Radius.circular(200)),
                                        hoverColor: AppKeys().customColors!.energyColor,
                                        onTap: () {},
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                          alignment: Alignment.center,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                'Hacer pedido',
                                                textAlign: TextAlign.center,
                                                style: CustomStyles.styleVolcanic16600.copyWith(color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.lock,
                                  size: 16,
                                  color: AppKeys().customColors!.white,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Transacción segura',
                                  style: GoogleFonts.inter(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0,
                                    color: AppKeys().customColors!.white,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                  ],
                ),
                SizedBox(height: media.height * 0.01),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ResumeBottom extends StackedHookView<ToBuyNowViewModel> {
  const ResumeBottom({Key? key, required this.scrollControllerBottom})
      : super(
          key: key,
        );

  final ScrollController scrollControllerBottom;

  @override
  Widget builder(
    BuildContext context,
    ToBuyNowViewModel model,
  ) {
    return Builder(
      builder: (BuildContext context) {
        var media = MediaQuery.of(context).size;

        return ListView(
          controller: scrollControllerBottom,
          padding: const EdgeInsets.only(right: 35.0, bottom: 25.0, left: 35.0),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                      // width: media.width,
                      width: clampDouble(360, media.width < 360 ? media.width : 360, 360),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 25.0),
                            child: Center(
                                child: SizedBox(
                              width: 38,
                              child: Divider(thickness: 5, color: Colors.white, height: 5),
                            )),
                          ),
                          Text(
                            'Realiza tu pedido',
                            style: GoogleFonts.inter(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w700,
                              fontSize: 42.0,
                              color: AppKeys().customColors!.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SelectableText(
                                'Productos',
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color: AppKeys().customColors!.white,
                                ),
                              ),
                              const Spacer(),
                              SelectableText(
                                model.currentValue.toStringAsFixed(0),
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: AppKeys().customColors!.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SelectableText(
                                'Subtotal',
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color: AppKeys().customColors!.white,
                                ),
                              ),
                              const Spacer(),
                              SelectableText(
                                model.currencyFormat.format(model.subtotalValue),
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: AppKeys().customColors!.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SelectableText(
                                'Dcto. adicional',
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color: AppKeys().customColors!.yellowVoltz,
                                ),
                              ),
                              const Spacer(),
                              SelectableText(
                                // '-${model.currencyFormat.format()}',
                                "000,000.000",
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: AppKeys().customColors!.yellowVoltz,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SelectableText(
                                'IVA (16%)',
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color: AppKeys().customColors!.white,
                                ),
                              ),
                              const Spacer(),
                              SelectableText(
                                model.currencyFormat.format(model.totalCalculateValue - model.subtotalValue),
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: AppKeys().customColors!.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SelectableText(
                                'Envio',
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color: AppKeys().customColors!.white,
                                ),
                              ),
                              const Spacer(),
                              // if (model.quote.shipping == null || model.quote.shipping!.total == 0) ...[
                              SelectableText(
                                'Gratis',
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: AppKeys().customColors!.white,
                                ),
                              ),
                              // ] else ...[
                              //   SelectableText(
                              //     model.currencyFormat.format(model.quote.shipping!.total),
                              //     style: GoogleFonts.inter(
                              //       fontStyle: FontStyle.normal,
                              //       fontWeight: FontWeight.w500,
                              //       fontSize: 16.0,
                              //       color: AppKeys().customColors!.white,
                              //     ),
                              //   ),
                              // ]
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class Resume extends StackedHookView<ToBuyNowViewModel> {
  const Resume({Key? key}) : super(key: key, reactive: true);

  @override
  Widget builder(
    BuildContext context,
    ToBuyNowViewModel model,
  ) {
    return Builder(
      builder: (BuildContext context) {
        var media = MediaQuery.of(context).size;

        return Container(
          color: AppKeys().customColors!.sidebarColor,
          width: 310,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 310.0,
                      padding: const EdgeInsets.only(top: 25.0, right: 35.0, bottom: 25.0, left: 35.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Realiza tu pedido',
                            style: GoogleFonts.inter(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w700,
                              fontSize: 42.0,
                              color: AppKeys().customColors!.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SelectableText(
                                'Productos',
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color: AppKeys().customColors!.white,
                                ),
                              ),
                              const Spacer(),
                              SelectableText(
                                model.currentValue.toStringAsFixed(0),
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: AppKeys().customColors!.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SelectableText(
                                'Subtotal',
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color: AppKeys().customColors!.white,
                                ),
                              ),
                              const Spacer(),
                              SelectableText(
                                model.currencyFormat.format(model.subtotalValue),
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: AppKeys().customColors!.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SelectableText(
                                'Dcto. adicional',
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color: AppKeys().customColors!.yellowVoltz,
                                ),
                              ),
                              const Spacer(),
                              SelectableText(
                                "000,000.000",
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: AppKeys().customColors!.yellowVoltz,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SelectableText(
                                'IVA (16%)',
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color: AppKeys().customColors!.white,
                                ),
                              ),
                              const Spacer(),
                              SelectableText(
                                model.currencyFormat.format(model.totalCalculateValue - model.subtotalValue),
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: AppKeys().customColors!.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SelectableText(
                                'Envio',
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color: AppKeys().customColors!.white,
                                ),
                              ),
                              const Spacer(),
                              //TODO determinar costo de envio por producto
                              SelectableText(
                                'Gratis',
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: AppKeys().customColors!.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      )),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 310,
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SelectableText(
                                '${model.currencyFormat.format(model.totalCalculateValue)} MXN',
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20.0,
                                  color: AppKeys().customColors!.white,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'total',
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.0,
                                  color: AppKeys().customColors!.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                  width: 250,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(200),
                                    ),
                                    color: AppKeys().customColors!.energyColor,
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: const BorderRadius.all(Radius.circular(200)),
                                      hoverColor: AppKeys().customColors!.energyColorHover,
                                      onTap: () {
                                        _Dialogs dialog = _Dialogs();
                                        dialog.showAlertDialog(
                                          context,
                                          () async {
                                            model.onGenerateOrder(context);
                                          },
                                          '',
                                          // model.createConfirmMessage(),
                                          model.product!.id!,
                                        );
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                                        alignment: Alignment.center,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              'Hacer pedido',
                                              textAlign: TextAlign.center,
                                              style: CustomStyles.styleVolcanic16600.copyWith(color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lock,
                                size: 16,
                                color: AppKeys().customColors!.white,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Transacción segura',
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.0,
                                  color: AppKeys().customColors!.white,
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                ],
              ),
            ],
          ),
        );
      },
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
          titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
          actionsOverflowButtonSpacing: 20,
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancelar")),
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

class _QuantityCalculatorWidget extends StackedHookView<ToBuyNowViewModel> {
  const _QuantityCalculatorWidget({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ToBuyNowViewModel viewModel,
  ) {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: AppKeys().customColors!.white,
          ),
          padding: const EdgeInsets.all(25),
          width: 362,
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 288,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(6),
                      ),
                      color: Color(0xFFE4E9FC),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 288,
                          height: 65,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6),
                            ),
                            color: const Color(0xFFE4E9FC),
                            border: Border.all(
                              color: AppKeys().customColors!.dark, //                   <--- border color
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              viewModel.disappearButtons
                                  ? Container()
                                  : Container(
                                      height: 60,
                                      width: 50,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(6),
                                          bottomRight: Radius.circular(6),
                                        ),
                                        color: Colors.transparent,
                                      ),
                                      alignment: Alignment.center,
                                      child: IconButton(
                                        mouseCursor: SystemMouseCursors.click,
                                        style: null,
                                        icon: const Icon(
                                          Icons.remove,
                                          size: 24,
                                        ),
                                        onPressed: () => viewModel.disappearButtonsFunc(),
                                      ),
                                    ),
                              Expanded(
                                child: InputTextV3(
                                  focusNode: viewModel.focusNodeInput,
                                  controller: viewModel.textEditingController,
                                  paddingContent: const EdgeInsets.only(bottom: 14, top: 19, left: 15),
                                  margin: const EdgeInsets.all(0),
                                  textStyle: GoogleFonts.inter(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22.0,
                                    color: AppKeys().customColors!.dark,
                                  ),
                                  textAlign: TextAlign.center,
                                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(6), topLeft: Radius.circular(6)),
                                  onTap: () async {
                                    viewModel.onTap();
                                  },
                                  onChanged: (value) async {
                                    viewModel.onQuantityChanged();
                                  },
                                  onEditingComplete: () {
                                    viewModel.onQuantityUpdated();
                                  },
                                  onFieldSubmitted: (v) {
                                    viewModel.onQuantityUpdated();
                                  },
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                                  inputFormatters: <TextInputFormatter>[
                                    // for below version 2 use this
                                    //FilteringTextInputFormatter.deny(RegExp(r'^\\s+$'), replacementString: 1.toString()),
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]+')),
                                    FilteringTextInputFormatter.deny(RegExp(r'^0+')), //users can't type 0 at 1st position),
                                    // for version 2 and greater youcan also use this
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                ),
                              ),
                              viewModel.showUpdateButton
                                  ? Container(
                                      color: Colors.transparent,
                                      width: 150,
                                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: 141.0,
                                        decoration: BoxDecoration(
                                          color: AppKeys().customColors!.dark,
                                          borderRadius: const BorderRadius.all(Radius.circular(200.0)),
                                        ),
                                        child: TextFieldTapRegion(
                                          child: TextButton(
                                            style: ButtonStyle(
                                              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                                (Set<MaterialState> states) {
                                                  return Colors.transparent;
                                                },
                                              ),
                                              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                                                (Set<MaterialState> states) {
                                                  return Colors.transparent;
                                                },
                                              ),
                                            ),
                                            onPressed: () {
                                              viewModel.onQuantityUpdated();
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              constraints: const BoxConstraints(
                                                minHeight: 30.0,
                                              ),
                                              child: Text(
                                                'Actualizar',
                                                style: GoogleFonts.inter(
                                                  fontStyle: FontStyle.normal,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13.0,
                                                  color: const Color(0xFF9C9FAA),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ))
                                  : const SizedBox.shrink(),
                              viewModel.disappearButtons
                                  ? Container()
                                  : Container(
                                      height: 60,
                                      width: 50,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(6),
                                          bottomRight: Radius.circular(6),
                                        ),
                                        color: Colors.transparent,
                                      ),
                                      alignment: Alignment.center,
                                      child: IconButton(
                                        mouseCursor: SystemMouseCursors.click,
                                        style: null,
                                        icon: const Icon(
                                          Icons.add,
                                          size: 24,
                                        ),
                                        onPressed: () => viewModel.disappearButtonsFunc(),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: const [
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 26,
                        child: Row(
                          children: [
                            SelectableText(
                              viewModel.currencyFormat.format(viewModel.totalCalculateValue),
                              style: GoogleFonts.inter(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w700,
                                fontSize: 22.0,
                                color: AppKeys().customColors!.dark,
                                height: 1.2,
                              ),
                              textAlign: TextAlign.left,
                              //overflow: TextOverflow.clip,
                            ),
                            Text(
                              ' +iva',
                              style: GoogleFonts.inter(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                                color: AppKeys().customColors!.dark,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '¡Disponibilidad inmediata!',
                        style: GoogleFonts.inter(
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                          color: AppKeys().customColors!.dark,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
