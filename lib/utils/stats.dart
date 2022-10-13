import 'package:flutter_segment/flutter_segment.dart';

class Stats {
  static QuoteViewed(String quoteId,) {
    Segment.screen(
      screenName: 'Cotizacion Vista',
      properties: {
        'quote_id': quoteId,
      },
    );
  }

  static OrderViewed(String orderId,) {
    Segment.screen(
      screenName: 'Pedido Visto',
      properties: {
        'order_id': orderId,
      },
    );
  }

  static ButtonClicked(String name){
    Segment.track(
      eventName: 'Boton Clicked',
      properties: {
        'button_name': name,
      },
    );
  }

  static QuoteAccepted(String quoteId, double total, ){
    Segment.track(
      eventName: 'Cotizacion Aceptada',
      properties: {
        'quote_id': quoteId,
        'total': total,
      },
    );
  }

  static SkuBorrado({required String quoteId, String? skuSuggested, String? productIdSuggested, required String productRequested, required int countProductsSuggested }){
    Segment.track(
      eventName: 'Sku Borrado',
      properties: {
        'quote_id': quoteId,
        'sku_suggested': skuSuggested,
        'product_id_suggested': productIdSuggested,
        'product_requested': productRequested,
        'count_products_suggested': countProductsSuggested
      },
    );
  }

  static SkuSeleccionado({required String quoteId, String? skuSuggested, String? productIdSuggested, required String productRequested, required int countProductsSuggested }){
    Segment.track(
      eventName: 'Sku Seleccionado',
      properties: {
        'quote_id': quoteId,
        'sku_suggested': skuSuggested,
        'product_id_suggested': productIdSuggested,
        'product_requested': productRequested,
        'count_products_suggested': countProductsSuggested
      },
    );
  }

}