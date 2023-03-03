import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart' as intl;
import 'package:maketplace/common/header.dart';
import 'package:maketplace/quote/quote_model.dart';
import 'package:maketplace/quote_detail/quote_detail_viewmodel.dart';
import 'package:maketplace/utils/custom_colors.dart';
import 'package:maketplace/utils/style.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class QuoteDetailListView extends StatelessWidget {
  const QuoteDetailListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuoteDetailViewModel>.reactive(
      viewModelBuilder: () => QuoteDetailViewModel(),
      onViewModelReady: (viewModel) => viewModel.init(),
      builder: (context, model, child) {
        var media = MediaQuery.of(context).size;

        return Scaffold(
          backgroundColor: CustomColors.WBY,
          body: Container(
            constraints: BoxConstraints(
              minWidth: CustomStyles.mobileBreak,
            ),
            color: CustomColors.WBY,
            child: Column(
              children: [
                const Header(),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(child: _CardGrid()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CardGrid extends StackedHookView<QuoteDetailViewModel> {
  const _CardGrid({Key? key}) : super(key: key, reactive: true);

  @override
  Widget builder(
    BuildContext context,
    QuoteDetailViewModel model,
  ) {
    var media = MediaQuery.of(context).size;
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(right: 25, left: 25),
          child: MasonryGridView.count(
            itemBuilder: (context, index) {
              return _ItemWidget(model: model.quoteDetailList[index]);
            },
            itemCount: model.quoteDetailList.length,
            mainAxisSpacing: 25,
            crossAxisSpacing: 25,
            crossAxisCount: ((media.width - 50) / 350).floor() != 0 ? ((media.width - 50) / 350).floor() : 1,
          ),
        );
      },
    );
  }
}

class _ItemWidget extends StatelessWidget {
  const _ItemWidget({Key? key, required this.model}) : super(key: key);
  final QuoteModel model;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 17),
      decoration: const BoxDecoration(color: CustomColors.white),
      width: 350,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(model.alias ?? ''),
                Row(
                  children: [
                    Text(
                      "creado a las ${intl.DateFormat("HH:mm, dd/MM", 'es_MX').format(model.createdAt!.toDate())}",
                    ),
                    const SizedBox(width: 5),
                    // if (model.author?.id != null) //
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      color: CustomColors.yellowVoltz,
                      child: const Text(
                        "ASISTIDO",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: EdgeInsets.all(7.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CustomColors.WBY,
            ),
            child: Text(model.consecutive.toString()),
          ),
        ],
      ),
    );
  }
}
