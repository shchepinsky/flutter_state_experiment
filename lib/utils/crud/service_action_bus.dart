import 'dart:async';

import 'service_action.dart';

class _ActionBus {
  StreamController<ServiceAction> _streamController = StreamController.broadcast();

  StreamSubscription<ServiceAction> listen(void onAction(ServiceAction action)) {
    return _streamController.stream.listen(onAction, onError: print);
  }

  void put(ServiceAction action) {
    final time = DateTime.now();
    print('${time} action: ${action.type} payload: ${action.payload}');
    _streamController.add(action);
  }

  Future<ServiceAction> take(Type actionClass) async {
    return await _streamController.stream
        .firstWhere((a) => a.runtimeType == actionClass);
  }

  Future<ServiceAction> takeAny(List<Type> actionClasses) async {
    return Future.any(actionClasses.map(this.take));
  }
}

_ActionBus actionBus = new _ActionBus();
