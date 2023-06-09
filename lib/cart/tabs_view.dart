import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maketplace/cart/backlog_view.dart';
import 'package:maketplace/cart/cart_expandable_view.dart';
import 'package:maketplace/cart/discard_view.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/quote/quote_viewmodel.dart';
import 'package:maketplace/utils/style.dart';
import 'package:stacked_hooks/stacked_hooks.dart' show StackedHookView;

class Tabs extends StatefulWidget {
  Tabs({Key? key, required this.tabController}) : super(key: key);
  TabController tabController;

  @override
  __TabsState createState() => __TabsState();
}

class __TabsState extends State<Tabs> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _setupTabs();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _setupTabs() {
    widget.tabController.animation!.addListener(() async {
      return setState(() {
        selectedIndex = widget.tabController.index;
      });
    });
    setState(() {
      selectedIndex = widget.tabController.index;
    });
    widget.tabController.addListener(() async {
      return setState(() {
        if (widget.tabController.indexIsChanging) selectedIndex = widget.tabController.index;
        // else if(widget.tabController.index != widget.tabController.previousIndex)
        //   selectedIndex = widget.tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _setupTabs();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        /*boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 50,
            offset: Offset(0, 0),
          ),
        ],*/
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TabBar(
              controller: widget.tabController,
              onTap: (value) {
                setState(() {
                  widget.tabController.index = value;
                });
              },
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 2.0,
                    color: AppKeys().customColors!.safeBlue,
                  ),
                  //insets: EdgeInsets.symmetric(horizontal:40.0),
                  insets: const EdgeInsets.symmetric(horizontal: 40)),
              //isScrollable: true,
              labelColor: AppKeys().customColors!.safeBlue,
              labelStyle: CustomStyles.styleMuggleGray18x600,
              unselectedLabelColor: AppKeys().customColors!.muggleGray_2,
              padding: EdgeInsets.zero,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(
                  height: 67,
                  key: Key("Cart"),
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (selectedIndex == 0) ...[
                          SvgPicture.asset(
                            'assets/svg/cart_icon.svg',
                            width: 24.0,
                            height: 24.0,
                            color: AppKeys().customColors!.safeBlue,
                          ),
                        ] else ...[
                          SvgPicture.asset('assets/svg/cart_icon.svg', width: 24.0, height: 24.0, color: AppKeys().customColors!.muggleGray_2),
                        ],
                        SizedBox(
                          width: 12,
                        ),
                        _textTab1(),
                      ],
                    ),
                  ),
                ),
                Tab(
                  height: 67,
                  key: const Key("Backlog"),
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (selectedIndex == 1) ...[
                          SvgPicture.asset(
                            'assets/svg/settings_icon.svg',
                            width: 24.0,
                            height: 24.0,
                            color: AppKeys().customColors!.safeBlue,
                          ),
                        ] else ...[
                          SvgPicture.asset('assets/svg/settings_icon.svg', width: 24.0, height: 24.0, color: AppKeys().customColors!.muggleGray_2),
                        ],
                        SizedBox(
                          width: 12,
                        ),
                        _textTab2(),
                      ],
                    ),
                  ),
                ),
                Tab(
                  height: 67,
                  key: const Key("Discarded"),
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (selectedIndex == 2) ...[
                          SvgPicture.asset(
                            'assets/svg/discarded_icon.svg',
                            width: 24.0,
                            height: 24.0,
                            color: AppKeys().customColors!.safeBlue,
                          ),
                        ] else ...[
                          SvgPicture.asset('assets/svg/discarded_icon.svg', width: 24.0, height: 24.0, color: AppKeys().customColors!.muggleGray_2),
                        ],
                        SizedBox(
                          width: 12,
                        ),
                        _textTab3(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}

class _textTab1 extends StackedHookView<QuoteViewModel> {
  const _textTab1({Key? key}) : super(key: key, reactive: true);

  @override
  Widget builder(
    BuildContext context,
    QuoteViewModel model,
  ) {
    if (model.quote.detail != null) {
      return Text("Productos cotizados (${model.quote.detail!.length})");
    } else {
      return Text("Productos cotizados");
    }
  }
}

class _textTab2 extends StackedHookView<QuoteViewModel> {
  const _textTab2({Key? key}) : super(key: key, reactive: true);

  @override
  Widget builder(
    BuildContext context,
    QuoteViewModel model,
  ) {
    if (model.quote.detail != null) {
      return Text("En proceso de cotización (${model.quote.pendingProducts!.length})");
    } else {
      return Text("En proceso de cotización");
    }
  }
}

class _textTab3 extends StackedHookView<QuoteViewModel> {
  const _textTab3({Key? key}) : super(key: key, reactive: true);

  @override
  Widget builder(
    BuildContext context,
    QuoteViewModel model,
  ) {
    if (model.quote.detail != null) {
      return Text("No incluidos (${model.quote.discardedProducts!.length})");
    } else {
      return Text("No incluidos");
    }
  }
}

class TabsContent extends StatefulWidget {
  TabsContent({
    Key? key,
    required this.tabController,
  }) : super(key: key);
  TabController tabController;
  @override
  __TabsContentState createState() => __TabsContentState();
}

class __TabsContentState extends State<TabsContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (authUser == null) return Loading();
    return TabBarView(controller: widget.tabController, dragStartBehavior: DragStartBehavior.start, children: [
      CardGrid(),
      BacklogView(),
      DiscardView(),
    ]);
  }
}
