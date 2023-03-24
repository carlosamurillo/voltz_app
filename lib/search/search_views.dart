import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/search/search_viewmodel.dart';
import 'package:maketplace/search/sliver_masonary_grid_view.dart' deferred as gv;
import 'package:maketplace/utils/buttons.dart';
import 'package:stacked/stacked.dart';

class SliverProductsSearchResult extends StatelessWidget {
  const SliverProductsSearchResult({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return ViewModelBuilder<ProductSearchViewModel>.reactive(
      viewModelBuilder: () => ProductSearchViewModel(),
      builder: (context, viewModel, child) {
        print('ProductsSearchResults view ... ');
        if (viewModel.lastQuery == null || viewModel.lastQuery!.isEmpty || viewModel.data == null) {
          return const SliverFillRemaining(
            child: SearchInitialViewWidget(),
          );
        }

        return FutureBuilder(
          future: gv.loadLibrary(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && viewModel.data!.isNotEmpty) {
              return gv.SliverProductGridView(childCount: viewModel.data!.length, data: viewModel.data!, onTapImprovePrice: viewModel.navigateToLogin, isHomeVersion: false);
            } else {
              return const SliverFillRemaining(
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
    return Center(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 35.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              AppKeys().assistantIcon!,
              width: 120,
            ),
            const SizedBox(height: 25),
            Text(
              "Busca por código, nombre, especificación, y/o marca.",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 32,
                color: AppKeys().customColors!.dark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Ejemplos: SML102022, Cable uso rudo, 16AMP, Tecnolite",
              style: TextStyle(
                fontSize: 18,
                color: AppKeys().customColors!.dark,
              ),
              textAlign: TextAlign.center,
            ),
          ],
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
                SelectableText(
                  "¿No lo encuentras?",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 32.0,
                    color: AppKeys().customColors!.dark,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Image.asset(
                  AppKeys().assistantIcon!,
                  width: 62,
                ),
                const SizedBox(height: 15),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "Buscaremos rápidamente ",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: AppKeys().customColors!.blueVoltz,
                      ),
                      children: [
                        TextSpan(
                          text: "el mejor precio y disponibilidad en cientos de proveedores",
                          style: TextStyle(color: AppKeys().customColors!.dark),
                        ),
                      ]),
                ),
                const SizedBox(height: 15),
                ThirdButton(
                    text: "Solicitar producto",
                    onPressed: () {
                      html.window.open('https://api.whatsapp.com/send/?phone=523313078145&text=Hola%2C+quiero+que+me+cotices%3A&type=phone_number&app_absent=0', "_blank");
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SliverClassicSearchView extends StatelessWidget {
  const SliverClassicSearchView({super.key, required this.isHomeVersion});
  final bool isHomeVersion;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductSearchViewModel>.reactive(
      viewModelBuilder: () => ProductSearchViewModel(),
      builder: (context, viewModel, child) {
        print('SliverClassicSearchView ... se renderiza...');
        return FutureBuilder(
          future: gv.loadLibrary(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && viewModel.data != null) {
              return gv.SliverProductGridView(
                  childCount: viewModel.data!.length, data: viewModel.data!, onTapImprovePrice: viewModel.navigateToLogin, isHomeVersion: isHomeVersion);
            } else {
              return const SliverToBoxAdapter(
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

class SliverSearchStatsView extends StatelessWidget {
  const SliverSearchStatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchStatsViewModel>.reactive(
      viewModelBuilder: () => SearchStatsViewModel(),
      builder: (context, viewModel, child) {
        print('SearchStatsView ... se renderiza...');
        return SliverToBoxAdapter(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 35),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Busca por código, nombre, especificación, y/o marca.",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 22.0,
                  color: AppKeys().customColors!.dark,
                ),
                textAlign: TextAlign.left,
              ),
              const Spacer(),
              if (viewModel.data != null) ...[
                Text(
                  '${viewModel.data!.nbHits} SKU disponibles',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                    color: AppKeys().customColors!.dark,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ],
          ),
        ));
      },
    );
  }
}

class HowToSearchBanner extends StatelessWidget {
  const HowToSearchBanner({super.key});

  @override
  Widget build(BuildContext context) {
    print('HowToSearchBanner ... se renderiza...');
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 50),
      height: 188,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppKeys().customColors!.energyColor,
        borderRadius: const BorderRadius.all(Radius.circular(6.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AppKeys().howToSearch!,
            height: 138,
            width: 138,
          ),
          const SizedBox(
            width: 25,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Busca por código, nombre, especificación, y/o marca.",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 32.0,
                    color: AppKeys().customColors!.bannerTextColor,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  "Ejemplos: SML102022, Cable uso rudo, 16AMP, y/o Tecnolite",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                    color: AppKeys().customColors!.bannerTextColor,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          )
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