import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:state_library_app/utils/crud/service.dart';
import 'package:state_library_app/utils/crud/service_actions.dart';
import 'package:state_library_app/utils/crud/service_state.dart';

typedef StateBuilderCallback<S1> = Widget Function(BuildContext ctx, S1 state1);

class StateBuilder<S1 extends ServiceState> extends StatefulWidget {
  final Service<S1, ServiceActions> service1;

  final StateBuilderCallback<S1> builder;

  StateBuilder({this.service1, this.builder}) {
    ArgumentError.checkNotNull(service1, 'service1');
    ArgumentError.checkNotNull(builder, 'builder');
  }

  @override
  State<StatefulWidget> createState() {
    return new StateBuilderState<S1>(this.service1, builder);
  }
}

class StateBuilderState<S1 extends ServiceState> extends State {
  Service<S1, ServiceActions> _service1;
  StreamSubscription _streamSubscription1;
  S1 _lastStream1State;

  final StateBuilderCallback<S1> builder;

  StateBuilderState(this._service1, this.builder) {
    _streamSubscription1 = _service1.stream.listen(_onData1);

    // supply initial state to initial builder call
    _lastStream1State = _service1.makeInitialState();
  }

  _onData1(S1 state) {
    setState(() => _lastStream1State = state);
  }

  @override
  Widget build(BuildContext context) {
    return builder(context, _lastStream1State);
  }

  @override
  void dispose() {
    _streamSubscription1.cancel();

    super.dispose();
  }
}
