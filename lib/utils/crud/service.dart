import 'dart:async';

import 'service_action.dart';
import 'service_action_bus.dart';
import 'service_actions.dart';
import 'service_state.dart';

abstract class Service<T extends ServiceState, A extends ServiceActions> {
  final String name;

  A actions;

  T _state;

  StreamController<T> _controller;

  Stream<T> get stream => _controller.stream;

  Service(String this.name) {
    _state = makeInitialState();
    _controller = new StreamController.broadcast(onListen: _onListen)
      ..add(_state);

    actionBus.listen(_onActionWrapper);
  }

  T get state => _state;

  _onListen() {
    // push initial state to listeners
    _controller.add(_state);
  }

  _onActionWrapper(ServiceAction action) {
    final nextState = reducer(_state, action);

    // detect state change and push update to listeners
    if (nextState != _state) {
      _state = nextState;
      _controller.add(nextState);
    }
  }

  T makeInitialState();

  T reducer(T state, ServiceAction action);

  close () {
    _controller.close();
  }
}
