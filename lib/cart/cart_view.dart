import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:maketplace/cart/cart_expandable_view.dart';
import 'package:maketplace/cart/container_viewmodel.dart';
import 'package:maketplace/cart/tabs_view.dart';
import 'package:maketplace/common/drawer.dart';
import 'package:maketplace/common/header.dart';
import 'package:maketplace/csv_quote/download_button.dart';
import 'package:maketplace/gate/auth_service.dart';
import 'package:maketplace/pdf_quote/download_button.dart';
import 'package:maketplace/quote/quote_viewmodel.dart';
import 'package:maketplace/search/search_views.dart';
import 'package:maketplace/utils/custom_colors.dart';
import 'package:maketplace/utils/style.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart' show StackedHookView;

class CartView extends StatelessWidget {
  const CartView({Key? key, required this.quoteId})
      : super(
          key: key,
        );
  final String quoteId;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ContainerViewModel>.reactive(
      viewModelBuilder: () => ContainerViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          endDrawer: model.userSignStatus == UserSignStatus.authenticated ? const MenuDrawer() : null,
          backgroundColor: CustomColors.WBY,
          // No appBar property provided, only the body.
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              // These are the slivers that show up in the "outer" scroll view.
              return <Widget>[
                const SliverHeader(),
                /*SliverOverlapAbsorber(
                    // This widget takes the overlapping behavior of the SliverAppBar,
                    // and redirects it to the SliverOverlapInjector below. If it is
                    // missing, then it is possible for the nested "inner" scroll view
                    // below to end up under the SliverAppBar even when the inner
                    // scroll view thinks it has not been scrolled.
                    // This is not necessary if the "headerSliverBuilder" only builds
                    // widgets that do not overlap the next sliver.
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                    sliver: const SliverHeader(),
                  ),*/
              ];
            },
            body: Builder(builder: (BuildContext context) {
              if (model.isSearchSelected) {
                return const CustomScrollView(
                    //physics: model.isSearchSelected ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
                    // Add the app bar and list of items as slivers in the next steps.
                    slivers: <Widget>[
                      /*SliverToBoxAdapter(
                              child: SizedBox(height: 25,),
                            ),
                            SliverSearchStatsView(),*/
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 25,
                        ),
                      ),
                      SliverProductsSearchResult(),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 25,
                        ),
                      ),
                    ]);
              }
              return _CartContainer(
                quoteId: quoteId,
              );
            }),
          ),
        );
      },
    );
  }
}

class CartView2 extends StatefulWidget {
  const CartView2({
    Key? key,
    required this.quoteId,
  }) : super(key: key);
  final String quoteId;

  @override
  CartViewState createState() => CartViewState();
}

class CartViewState extends State<CartView2> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.grayBackground_2,
        body: Stack(
          children: [
            Container(
              color: CustomColors.WBY,
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  const Header(),
                  _SliverContainer(
                    quoteId: widget.quoteId,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class _BottomExpandedAppBar extends StatelessWidget {
  const _BottomExpandedAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.2,
      minChildSize: 0.2,
      maxChildSize: 0.7,
      builder: (context, scrollControllerBottom) {
        return ColoredBox(
          color: CustomColors.safeBlue,
          // color: CustomColors.redAlert,
          child: ResumeBottom(scrollControllerBottom: scrollControllerBottom),
        );
      },
    );
  }
}

class _BottomReminderTakeOrder extends StackedHookView<QuoteViewModel> {
  const _BottomReminderTakeOrder({Key? key}) : super(key: key, reactive: true);

  @override
  Widget builder(
    BuildContext context,
    QuoteViewModel model,
  ) {
    return Builder(builder: (context) {
      var media = MediaQuery.of(context).size;
      if (model.quote.detail != null) {
        return Container(
          color: CustomColors.safeBlue,
          width: media.width,
          height: media.height * 0.15,
          child: SingleChildScrollView(
            controller: ScrollController(),
            // physics: const NeverScrollableScrollPhysics(),
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
                                  '${model.currencyFormat.format(model.quote.totals!.total)} MXN',
                                  style: GoogleFonts.inter(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.0,
                                    color: CustomColors.white,
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
                                    color: CustomColors.white,
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
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(200),
                                      ),
                                      color: CustomColors.energyYellow,
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: const BorderRadius.all(Radius.circular(200)),
                                        hoverColor: CustomColors.energyYellowHover,
                                        onTap: () {
                                          _Dialogs dialog = _Dialogs();
                                          dialog.showAlertDialog(
                                            context,
                                            () async {
                                              model.onGenerateOrder(context);
                                            },
                                            model.createConfirmMessage(),
                                            model.quote.id!,
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
                                                style: CustomStyles.styleVolcanic16600,
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
                                const Icon(
                                  Icons.lock,
                                  size: 16,
                                  color: CustomColors.white,
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
                                    color: CustomColors.white,
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
          ),
        );
      } else {
        return Container(color: CustomColors.safeBlue);
      }
    });
  }
}

class Resume extends StackedHookView<QuoteViewModel> {
  const Resume({Key? key}) : super(key: key, reactive: true);

  @override
  Widget builder(
    BuildContext context,
    QuoteViewModel model,
  ) {
    return Builder(
      builder: (BuildContext context) {
        var media = MediaQuery.of(context).size;
        if (model.quote.detail != null) {
          return Container(
            color: CustomColors.safeBlue,
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
                              'Realiza tu pedido ya',
                              style: GoogleFonts.inter(
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w700,
                                fontSize: 42.0,
                                color: CustomColors.white,
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
                                    color: CustomColors.white,
                                  ),
                                ),
                                const Spacer(),
                                SelectableText(
                                  model.selectedProducts.length.toString(),
                                  style: GoogleFonts.inter(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: CustomColors.white,
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
                                    color: CustomColors.white,
                                  ),
                                ),
                                const Spacer(),
                                SelectableText(
                                  model.currencyFormat.format(model.quote.totals!.subTotal!),
                                  style: GoogleFonts.inter(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: CustomColors.white,
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
                                    color: CustomColors.yellowVoltz,
                                  ),
                                ),
                                const Spacer(),
                                SelectableText(
                                  '-${model.currencyFormat.format(model.quote.totals!.discount!)}',
                                  style: GoogleFonts.inter(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: CustomColors.yellowVoltz,
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
                                    color: CustomColors.white,
                                  ),
                                ),
                                const Spacer(),
                                SelectableText(
                                  model.currencyFormat.format(model.quote.totals!.tax),
                                  style: GoogleFonts.inter(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: CustomColors.white,
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
                                    color: CustomColors.white,
                                  ),
                                ),
                                const Spacer(),
                                if (model.quote.shipping == null || model.quote.shipping!.total == 0) ...[
                                  SelectableText(
                                    'Gratis',
                                    style: GoogleFonts.inter(
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                      color: CustomColors.white,
                                    ),
                                  ),
                                ] else ...[
                                  SelectableText(
                                    model.currencyFormat.format(model.quote.shipping!.total),
                                    style: GoogleFonts.inter(
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0,
                                      color: CustomColors.white,
                                    ),
                                  ),
                                ]
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
                                  '${model.currencyFormat.format(model.quote.totals!.total)} MXN',
                                  style: GoogleFonts.inter(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.0,
                                    color: CustomColors.white,
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
                                    color: CustomColors.white,
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
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(200),
                                      ),
                                      color: CustomColors.energyYellow,
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: const BorderRadius.all(Radius.circular(200)),
                                        hoverColor: CustomColors.energyYellowHover,
                                        onTap: () {
                                          _Dialogs dialog = _Dialogs();
                                          dialog.showAlertDialog(
                                            context,
                                            () async {
                                              model.onGenerateOrder(context);
                                            },
                                            model.createConfirmMessage(),
                                            model.quote.id!,
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
                                                style: CustomStyles.styleVolcanic16600,
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
                                const Icon(
                                  Icons.lock,
                                  size: 16,
                                  color: CustomColors.white,
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
                                    color: CustomColors.white,
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
        } else {
          return Container(color: CustomColors.safeBlue);
        }
      },
    );
  }
}

class ResumeBottom extends StackedHookView<QuoteViewModel> {
  const ResumeBottom({Key? key, required this.scrollControllerBottom}) : super(key: key, reactive: true);

  final ScrollController scrollControllerBottom;
  @override
  Widget builder(
    BuildContext context,
    QuoteViewModel model,
  ) {
    return Builder(
      builder: (BuildContext context) {
        var media = MediaQuery.of(context).size;
        if (model.quote.detail != null) {
          return ListView(
            controller: scrollControllerBottom,
            padding: const EdgeInsets.only(top: 25.0, right: 35.0, bottom: 25.0, left: 35.0),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 360,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Divider(thickness: 5, color: Colors.white, height: 5, indent: 136, endIndent: 136),
                          const SizedBox(height: 25),
                          Text(
                            'Realiza tu pedido ya',
                            style: GoogleFonts.inter(
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w700,
                              fontSize: 42.0,
                              color: CustomColors.white,
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
                                  color: CustomColors.white,
                                ),
                              ),
                              const Spacer(),
                              SelectableText(
                                model.selectedProducts.length.toString(),
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: CustomColors.white,
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
                                  color: CustomColors.white,
                                ),
                              ),
                              const Spacer(),
                              SelectableText(
                                model.currencyFormat.format(model.quote.totals!.subTotal!),
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: CustomColors.white,
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
                                  color: CustomColors.yellowVoltz,
                                ),
                              ),
                              const Spacer(),
                              SelectableText(
                                '-${model.currencyFormat.format(model.quote.totals!.discount!)}',
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: CustomColors.yellowVoltz,
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
                                  color: CustomColors.white,
                                ),
                              ),
                              const Spacer(),
                              SelectableText(
                                model.currencyFormat.format(model.quote.totals!.tax),
                                style: GoogleFonts.inter(
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: CustomColors.white,
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
                                  color: CustomColors.white,
                                ),
                              ),
                              const Spacer(),
                              if (model.quote.shipping == null || model.quote.shipping!.total == 0) ...[
                                SelectableText(
                                  'Gratis',
                                  style: GoogleFonts.inter(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: CustomColors.white,
                                  ),
                                ),
                              ] else ...[
                                SelectableText(
                                  model.currencyFormat.format(model.quote.shipping!.total),
                                  style: GoogleFonts.inter(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: CustomColors.white,
                                  ),
                                ),
                              ]
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      )),
                ],
              ),
            ],
          );
        } else {
          return Container(color: CustomColors.safeBlue);
        }
      },
    );
  }
}

class _SliverContainer extends StatelessWidget {
  const _SliverContainer({
    Key? key,
    required this.quoteId,
  }) : super(
          key: key,
        );

  final String quoteId;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ContainerViewModel>.reactive(
      viewModelBuilder: () => ContainerViewModel(),
      builder: (context, model, child) {
        if (model.isSearchSelected) return const SliverProductsSearchResult();

        return SliverToBoxAdapter(
          child: _CartContainer(
            quoteId: quoteId,
          ),
        );
      },
    );
  }
}

class _CartContainer extends StatelessWidget {
  const _CartContainer({
    Key? key,
    required this.quoteId,
  }) : super(
          key: key,
        );

  final String quoteId;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuoteViewModel>.nonReactive(
      viewModelBuilder: () => QuoteViewModel(),
      onViewModelReady: (viewModel) => viewModel.init(quoteId),
      builder: (context, model, child) {
        var media = MediaQuery.of(context).size;

        return Stack(
          children: [
            Container(
              constraints: BoxConstraints(
                minWidth: CustomStyles.mobileBreak,
              ),
              width: media.width,
              // height: media.width >= CustomStyles.desktopBreak ? media.height - CustomStyles.desktopHeaderHeight : media.height - CustomStyles.mobileHeaderHeight,
              color: CustomColors.WBY,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CardGrid(),
                  // if (media.width >= CustomStyles.mobileBreak) ...[
                  //   const Resume(),
                  // ]
                ],
              ),
            ),
            if (media.width < CustomStyles.mobileBreak) ...[
              const _BottomExpandedAppBar(),
              const Positioned(bottom: 0, child: _BottomReminderTakeOrder()),
            ]
          ],
        );
      },
    );
  }
}

class CustomerInfo extends StackedHookView<QuoteViewModel> {
  const CustomerInfo({
    Key? key,
  }) : super(key: key, reactive: true);

  @override
  Widget builder(
    BuildContext context,
    QuoteViewModel model,
  ) {
    if (model.quote.customer != null) {
      var media = MediaQuery.of(context).size;
      return Container(
        padding: const EdgeInsets.all(25),
        width: media.width >= CustomStyles.mobileBreak ? (media.width - 310 - 50) : media.width - 50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (media.width >= CustomStyles.desktopBreak) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (model.customerName != null) ...[
                    const Icon(Icons.perm_identity, size: 24),
                    const SizedBox(
                      width: 9,
                    ),
                    SelectableText(
                      model.customerName!,
                      style: GoogleFonts.inter(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                        color: CustomColors.dark,
                      ),
                    ),
                  ],
                  if (model.companyName != null) ...[
                    const SizedBox(
                      width: 18,
                    ),
                    const Icon(Icons.business, size: 24),
                    const SizedBox(
                      width: 9,
                    ),
                    SelectableText(
                      model.companyName!,
                      style: GoogleFonts.inter(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                        color: CustomColors.dark,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10),
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: media.width >= CustomStyles.mobileBreak ? (media.width - 310 - 50) : media.width - 50,
                  child: Text(
                    model.quote.alias!,
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        fontSize: media.width >= CustomStyles.desktopBreak ? 42.0 : 32,
                        color: CustomColors.dark,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    maxLines: 4,
                  ),
                ),
              ],
            ),
            if (media.width >= CustomStyles.desktopBreak) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  SizedBox(width: 10),
                  PDFDownloadButton(),
                  SizedBox(width: 10),
                  CsvDownloadButton(),
                ],
              ),
            ]
          ],
        ),
      );
    } else {
      return Container();
    }
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
    return Container(
      //padding: EdgeInsets.only(top: 20, left: 30, right: 30),
      margin: const EdgeInsets.only(top: 20, left: 50, right: 50),
      child: Column(
        children: [
          Tabs(
            tabController: _tabController,
          ),
          const SizedBox(
            width: 200,
            height: 25,
          ),
          Expanded(
            child: TabsContent(
              tabController: _tabController,
            ),
          ),
        ],
      ),
    );
  }
}

class ComebackLater extends StatelessWidget {
  const ComebackLater({super.key, required this.totalProducts});
  final int totalProducts;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: const Color(0xFFFBE597).withOpacity(0.5),
        ),
        width: 362,
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
                  'Estamos cotizando tus productos restantes ($totalProducts)',
                  style: CustomStyles.styleMuggleGray_416x700,
                  textAlign: TextAlign.left,
                  //overflow: TextOverflow.clip,
                ),
                const SizedBox(
                  height: 10,
                ),
                SelectableText.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Te los iremos agregando a esta lista. ¡Estate atento!\nNuestros expertos están buscando el mejor precio, en cientos de proveedores.',
                        style: CustomStyles.styleMuggleGray_414x400,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 10,
                ),
                SelectableText(
                  'Ver productos pendientes',
                  style: CustomStyles.styleSafeBlue14x400,
                  textAlign: TextAlign.left,
                  //overflow: TextOverflow.clip,
                ),
              ],
            )
          ],
        ));
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
