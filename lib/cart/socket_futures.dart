
import 'dart:async';

// This classes are experimental and is not ready
class CompleterModel {
  final Completer<bool> completer = Completer();
  late Timer timer;
  static int milliToWait = 1000;

  run({required Future<bool> future,}) async {
    timer = Timer(Duration(milliseconds: CompleterModel.milliToWait), () {
      completer.complete(future);
    });
  }

  Future<bool> tryCancel () async {
    if (timer.isActive == true && completer.isCompleted == false) {
      timer.cancel();
      completer.complete(false);
      print('CANCELADO CANCELADO CANCELADO CANCELADO CANCELADO CANCELADO CANCELADO CANCELADO CANCELADO ');
      return true;
    }
    return false;
  }
}

class QueueService {
  final Map<String, CompleterModel> _requests = {};

  Future<bool> add({required Future<bool> future, required String requestId}) async {
    if (_requests.containsKey(requestId) && !_requests[requestId]!.completer.isCompleted) {
      print('no esta completo');
      bool res = false;
      do {
        res = await _requests[requestId]!.tryCancel();
      } while(res == false);
    }
    CompleterModel completeModel = CompleterModel();
    _requests[requestId] = completeModel;
    await _requests[requestId]!.run(future: future);
    return _requests[requestId]!.completer.future;
  }
}