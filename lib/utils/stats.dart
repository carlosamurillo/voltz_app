import 'package:flutter_segment/flutter_segment.dart';

class Stats {
  static QuoteViewed() {
    Segment.screen(
      screenName: 'Cotizacion',
    );
    Segment.flush();
  }

  static OrderViewed() {
    Segment.screen(
      screenName: 'Pedido',
    );
    Segment.flush();
  }

  static ButtonClicked(String name){
    Segment.track(
      eventName: 'ButtonClicked',
      properties: {
        'name': name,
      },
    );
  }
}