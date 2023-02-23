
import 'dart:async';
import 'package:maketplace/quote/quote_model.dart';

class QuoteStream {
  QuoteStream();

  add(QuoteModel quote) {
    _controller.sink.add(quote);
  }

  final _controller = StreamController<QuoteModel>();
  Stream<QuoteModel> get stream => _controller.stream;
}