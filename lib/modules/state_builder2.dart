import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:state_library_app/utils/crud/service.dart';
import 'package:state_library_app/utils/crud/service_actions.dart';
import 'package:state_library_app/utils/crud/service_state.dart';

typedef StateBuilder2Callback<S1, S2> = Widget Function(
    BuildContext ctx, S1 state1, S2 state2);

class StateBuilder2<S1 extends ServiceState, S2 extends ServiceState>
    extends StatefulWidget {
  final Service<S1, ServiceActions> service1;
  final Service<S2, ServiceActions> service2;

  final StateBuilder2Callback<S1, S2> builder;

  StateBuilder2({this.service1, this.service2, this.builder}) {
    ArgumentError.checkNotNull(service1, 'service1');
    ArgumentError.checkNotNull(service2, 'service2');
    ArgumentError.checkNotNull(builder, 'builder');
  }

  @override
  State<StatefulWidget> createState() {
    return new StateBuilder2State<S1, S2>(
        this.service1, this.service2, builder);
  }
}

class StateBuilder2State<S1 extends ServiceState, S2 extends ServiceState>
    extends State {
  Service<S1, ServiceActions> _service1;
  StreamSubscription _streamSubscription1;
  S1 _lastStream1State;

  Service<S2, ServiceActions> _service2;
  StreamSubscription _streamSubscription2;
  S2 _lastStream2State;

  final StateBuilder2Callback<S1, S2> builder;

  StateBuilder2State(this._service1, this._service2, this.builder) {
    _streamSubscription1 = _service1.stream.listen(_onData1);
    _streamSubscription2 = _service2.stream.listen(_onData2);

    // supply initial state to initial builder call
    _lastStream1State = _service1.makeInitialState();
    _lastStream2State = _service2.makeInitialState();
  }

  _onData1(S1 state) {
    setState(() => _lastStream1State = state);
  }

  _onData2(S2 state) {
    setState(() => _lastStream2State = state);
  }

  @override
  Widget build(BuildContext context) {
    return builder(context, _lastStream1State, _lastStream2State);
  }

  @override
  void dispose() {
    _streamSubscription1.cancel();
    _streamSubscription2.cancel();

    super.dispose();
  }
}
