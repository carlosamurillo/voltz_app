
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maketplace/quote/quote_model.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';


class QuoteService with ReactiveServiceMixin {

  final RxValue<QuoteModel> _rxQuote = RxValue<QuoteModel>(QuoteModel());
  QuoteModel get quote => _rxQuote.value;

  QuoteService(){
    listenToReactiveValues([_rxQuote,]);
  }

  void init() async {
    _listenChanges();
  }

  void _listenChanges() async {
    DocumentReference reference = FirebaseFirestore.instance.collection('quote-detail').doc("SWCTsMKJJ9mvatWyNuxQ");
    reference.snapshots().listen((documentSnapshot) async {
      print(documentSnapshot.data().toString());
      print("AAA");
      if (documentSnapshot.exists) {
        print("BB");
        _rxQuote.value = QuoteModel.fromJson(documentSnapshot.data() as Map<String, dynamic>, documentSnapshot.id);
        print("CC");
        notifyListeners();
        print("DD");
      } else {
        _rxQuote.value = QuoteModel();
      }
    });
  }

  QuoteModel _getQuote(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    QuoteModel quote;

    quote = QuoteModel(
      customerId: data['customer_id'],
      alias: data['alias'],
      subTotal: data['sub_total'],
      discount: data['discount'],
      tax: data['tax'],
      total: data['total'],
      createdAt: data['expiration_date'],
    );

    List<DiscardedProducts> discardedProductsList = [];
    List<dynamic>? discardedProducts = data['discarded_products'];
    discardedProducts?.forEach((element) {
      DiscardedProducts discardedProducts = DiscardedProducts(
        reason: element['reason'],
        requestedProducts: element['requested_products'],
      );
      discardedProductsList.add(discardedProducts);
    });
    quote.discardedProducts = discardedProductsList;

    List<Detail> detailList = [];
    List<dynamic>? detail = data['detail'];
    detail?.forEach((element) {
      Detail detail = Detail(
          productRequested: element['product_requested'],
          productsSuggested: []
      );
      List<dynamic> productSuggested = element['products_suggested'];
      for (var element in productSuggested) {
        detail.productsSuggested?.add(
            ProductsSuggested(
              productId: element['product_id'],
              sku: element['sku'],
              supplier: element['supplier'],
              skuDescription: element['sku_description'],
              brand: element['brand'],
              subBrand: element['sub_brand'],
              quantity: element['quantity'],
              saleValue: element['sale_value'],
              saleUnit: element['sale_unit'],
              salePrice: element['sale_price'],
              selected: element['selected'],
            )
        );
      }
      detailList.add(detail);
    });
    quote.detail = detailList;

    return quote;
  }

  onQuantityChange(int detailProductRequestedIndex, int detailProductSuggestedIndex, int quantity){
    print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
    var fieldName = "detail.$detailProductRequestedIndex.products_suggested.$detailProductSuggestedIndex.quantity";
    print (fieldName);

    print('TTTTTTTTTTTTTTTTTTTTT');
  }
}