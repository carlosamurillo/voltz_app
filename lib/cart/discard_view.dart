import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/quote/quote_model.dart';
import 'package:maketplace/quote/quote_viewmodel.dart';
import 'package:maketplace/utils/style.dart';
import 'package:stacked_hooks/stacked_hooks.dart' show StackedHookView;

class DiscardView extends StackedHookView<QuoteViewModel> {
  DiscardView({
    Key? key,
  }) : super(key: key, reactive: true);

  @override
  Widget builder(
    BuildContext context,
    QuoteViewModel viewModel,
  ) {
    return Builder(
      builder: (BuildContext context) {
        if (viewModel.quote.discardedProducts != null) {
          return Container(
            color: Colors.white,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
              reverse: false,
              controller: viewModel.scrollController,
              itemCount: viewModel.quote.discardedProducts!.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return NoIncludeSign();
                } else {
                  return _BacklogItemView(product: viewModel.quote.discardedProducts![index - 1]);
                }
              },
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
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
        ));
  }
}

class _BacklogItemView extends StackedHookView<QuoteViewModel> {
  const _BacklogItemView({Key? key, required this.product}) : super(key: key, reactive: true);

  final DiscardedProducts product;

  @override
  Widget builder(
    BuildContext context,
    QuoteViewModel viewModel,
  ) {
    return Container(
        margin: const EdgeInsets.only(
          top: 0,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppKeys().customColors!.muggleGray, width: 1),
          color: Colors.white,
        ),
        child: Row(
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
                child: SelectableText.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: product.requestedProducts!.replaceAll("<em>", "").replaceAll("<\/em>", ""),
                        style: CustomStyles.styleMuggleGray_414x400,
                      ),
                      TextSpan(
                        text: "\n${product.reason}",
                        style: CustomStyles.styleRedAlert16x400,
                      )
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            )
          ],
        ));
  }
}
