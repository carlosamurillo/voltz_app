
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:maketplace/search/search_views.dart';
import '../product/product_model.dart';
import '../product/product_views.dart';
import '../utils/style.dart';

class ProductGridView extends StatelessWidget {
  const ProductGridView({super.key, required this.childCount, required this.data, required this.onTapImprovePrice});
  final int childCount;
  final List<Product> data;
  final Function onTapImprovePrice;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SizedBox(
      width: media.width,
      height: media.width >= CustomStyles.desktopBreak ? media.height - CustomStyles.desktopHeaderHeight : media.height - CustomStyles.mobileHeaderHeight,
      child: CustomScrollView(
        slivers: <Widget> [
          const SliverToBoxAdapter(
            child: SizedBox(height: 25,),
          ),
          SliverProductGridView(childCount: data.length, data: data, onTapImprovePrice: onTapImprovePrice,),
          const SliverToBoxAdapter(
            child: SizedBox(height: 25,),
          ),
        ],
      ),);
  }
}

class SliverProductGridView extends StatelessWidget {
  const SliverProductGridView({super.key, required this.childCount, required this.data, required this.onTapImprovePrice});
  final int childCount;
  final List<Product> data;
  final Function onTapImprovePrice;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    if(data.isNotEmpty){
      return SliverPadding(
        padding: media.width >= CustomStyles.mobileBreak ? const EdgeInsets.only(right: 25, left: 25) 
            : const EdgeInsets.only(right: 0, left: 0),
        sliver: SliverMasonryGrid.count(
          childCount: data.length,
          mainAxisSpacing: 25,
          crossAxisSpacing: 25,
          itemBuilder: (context, index) {
            if(index == data.length - 1){
              return const NoFoundCard();
            }
            return ProductCard(
                product: data[index], onTapImprovePrice: onTapImprovePrice,
            );
          }, crossAxisCount: ((media.width - 25) / 387).truncateToDouble().toInt() != 0 ? ((media.width - 25) / 387).truncateToDouble().toInt() : 1,
        ),
      );
    } else {
      return const SliverToBoxAdapter(child: SizedBox(),);
    }
  }
}