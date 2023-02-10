
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maketplace/search/search_viewmodel.dart';
import 'package:stacked/stacked.dart';

import '../product/product_views.dart';
import '../utils/custom_colors.dart';
import '../utils/style.dart';

class ProductsSearchResult extends StatelessWidget {
  const ProductsSearchResult({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return ViewModelBuilder<ProductSearchViewModel>.reactive(
      viewModelBuilder: () => ProductSearchViewModel(),
      fireOnViewModelReadyOnce: false,
      createNewViewModelOnInsert: true,
      builder: (context, viewModel, child) {
        print('............................................' + media.height.toString());
        if(viewModel.lastQuery == null || viewModel.lastQuery!.isEmpty){
          return const SearchInitialViewWidget();
        }

        if(viewModel.data == null) {
          return const Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(),
            ),
          );
        }
        return SizedBox(
          width: media.width,
          height: media.width >= CustomStyles.desktopBreak ? media.height - CustomStyles.desktopHeaderHeight : media.height - CustomStyles.mobileHeaderHeight,
          child: CustomScrollView(
            slivers: <Widget> [
              const SliverToBoxAdapter(
                child: SizedBox(height: 25,),
              ),
              if(viewModel.data!.isNotEmpty) ...[
                SliverPadding(
                  padding: media.width >= CustomStyles.mobileBreak ? const EdgeInsets.only(right: 25, left: 25) : const EdgeInsets.only(right: 0, left: 0),
                  sliver: SliverMasonryGrid.count(
                    childCount: viewModel.data!.length,
                    mainAxisSpacing: 25,
                    crossAxisSpacing: 25,
                    itemBuilder: (context, index) {
                      if(index == viewModel.data!.length - 1){
                        return const NoFoundCard();
                      }
                      return ProductCard(
                          product: viewModel.data![index]
                      );
                    }, crossAxisCount: ((media.width - 25) / 387).truncateToDouble().toInt() != 0 ? ((media.width - 25) / 387).truncateToDouble().toInt() : 1,
                  ),
                ),
              ],
              const SliverToBoxAdapter(
                child: SizedBox(height: 25,),
              ),
            ],
          ),);
        },
    );
  }
}

class SearchInitialViewWidget extends StatelessWidget {
  const SearchInitialViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                "assets/images/assistant_icon.png",
                width: 120,
              ),
              const SizedBox(height: 25),
              const Text(
                "Busca por código, nombre, especificación, y/o marca.",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 32,
                  color: CustomColors.dark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Ejemplos: SML102022, Cable uso rudo, 16AMP, Tecnolite",
                style: TextStyle(
                  fontSize: 18,
                  color: CustomColors.dark,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoFoundCard extends StatelessWidget {
  const NoFoundCard({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 362.0,
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 362.0,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 56),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 25),
                const SelectableText(
                  "¿No lo encuentras?",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 32.0,
                    color: CustomColors.dark,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Image.asset(
                  "assets/images/assistant_icon.png",
                  width: 62,
                ),
                const SizedBox(height: 15),
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                      text: "Buscaremos rápidamente ",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: CustomColors.blueVoltz,
                      ),
                      children: [
                        TextSpan(
                          text: "el mejor precio y disponibilidad en cientos de proveedores",
                          style: TextStyle(color: CustomColors.dark),
                        ),
                      ]),
                ),
                const SizedBox(height: 15),
                Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: CustomColors.dark,
                      borderRadius: BorderRadius.all(Radius.circular(200.0)),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: const BorderRadius.all(Radius.circular(200)),
                        hoverColor: CustomColors.dark.withOpacity(.8),
                        onTap: () {},
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          alignment: Alignment.center,
                          child: Text(
                            'Solicitar producto',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                              color: CustomColors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


/*class ProductsSearchResult extends StatelessWidget {
  const ProductsSearchResult({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductSearchViewModel>.reactive(
      builder: (context, viewModel, child) => Scaffold(
        body: Center(
          child: Column(children: <Widget>[
            Expanded(
              child: PagedSliverGrid<int, ProductSearch>(
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: ((media.width - 310 - 25) / 387).truncateToDouble().toInt() != 0 ? ((media.width - 310 - 25) / 387).truncateToDouble().toInt() : 1,),
                  pagingController: viewModel.pagingController,
                  builderDelegate: PagedChildBuilderDelegate<ProductSearch>(
                      noItemsFoundIndicatorBuilder: (_) => const Center(
                        child: Text('No results found'),
                      ),
                      itemBuilder: (_, item, __) => Container(
                        color: Colors.white,
                        height: 80,
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            SizedBox(width: 50, child: Image.network(item.image)),
                            const SizedBox(width: 20),
                            Expanded(child: Text(item.name))
                          ],
                        ),
                      ))),
            )
          ],)
          ,
        ),
      ),
      viewModelBuilder: () => ProductSearchViewModel(),
    );
  }
}*/