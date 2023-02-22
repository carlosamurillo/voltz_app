import 'package:flutter/material.dart';
import 'package:maketplace/search/search_viewmodel.dart';
import 'package:maketplace/search/sliver_masonary_grid_view.dart' deferred as gv;
import 'package:maketplace/utils/buttons.dart';
import 'package:stacked/stacked.dart';

import '../utils/custom_colors.dart';

class ProductsSearchResult extends StatelessWidget {
  const ProductsSearchResult({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return ViewModelBuilder<ProductSearchViewModel>.reactive(
      viewModelBuilder: () => ProductSearchViewModel(),
      builder: (context, viewModel, child) {
        print('ProductsSearchResults view ... ');
        if(viewModel.lastQuery == null || viewModel.lastQuery!.isEmpty || viewModel.data == null){
          return const SearchInitialViewWidget();
        }

        return FutureBuilder(
          future: gv.loadLibrary(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && viewModel.data!.isNotEmpty) {
              return gv.ProductGridView(childCount: viewModel.data!.length, data: viewModel.data!);
            } else {
              return const Expanded(
                child: Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }
          },
        );
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

class SearchNotFoundWidget extends StatelessWidget {
  const SearchNotFoundWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Center(
        child: NoFoundCard(),
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
                ThirdButton(text: "Solicitar producto", onPressed: () {}),
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