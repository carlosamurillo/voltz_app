
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maketplace/cart/buy_now_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../common/app_bar_view.dart';
import '../product/product_views.dart';
import '../utils/custom_colors.dart';

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
          return Scaffold(
            backgroundColor: CustomColors.blueVoltz,
            appBar: BlueAppBar(
              context: context,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if(viewModel.product != null) ...[
                      SizedBox(
                        width: 362,
                        child: ProductCard(product: viewModel.product!, isCartVersion: true, isSearchVersion: false),
                      ),
                    ] else ...[
                      Container(
                          padding: const EdgeInsets.all(25.0),
                          decoration: const BoxDecoration(
                            color: CustomColors.blueVoltz,
                          ),
                          child: const Center(
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(color: CustomColors.white,),
                            ),
                          )
                      ),
                    ],
                  ],
                ),
              ],
            )
          );
        });
  }

}