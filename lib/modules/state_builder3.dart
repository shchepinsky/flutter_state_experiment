import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:state_library_app/utils/crud/service.dart';
import 'package:state_library_app/utils/crud/service_actions.dart';
import 'package:state_library_app/utils/crud/service_state.dart';

typedef StateBuilder3Callback<S1, S2, S3> = Widget Function(
    BuildContext ctx, S1 state1, S2 state2, S3 state3);

class StateBuilder3<S1 extends ServiceState, S2 extends ServiceState,
    S3 extends ServiceState> extends StatefulWidget {
  final Service<S1, ServiceActions> service1;
  final Service<S2, ServiceActions> service2;
  final Service<S3, ServiceActions> service3;

  final StateBuilder3Callback<S1, S2, S3> builder;

  StateBuilder3({this.service1, this.service2, this.service3, this.builder}) {
    ArgumentError.checkNotNull(service1, 'service1');
    ArgumentError.checkNotNull(service2, 'service2');
    ArgumentError.checkNotNull(service3, 'service3');
    ArgumentError.checkNotNull(builder, 'builder');
  }

  @override
  State<StatefulWidget> createState() {
    return new StateBuilder3State<S1, S2, S3>(
        this.service1, this.service2, service3, builder);
  }
}

class StateBuilder3State<S1 extends ServiceState, S2 extends ServiceState,
    S3 extends ServiceState> extends State {
  Service<S1, ServiceActions> _service1;
  StreamSubscription _streamSubscription1;
  S1 _lastStream1State;

  Service<S2, ServiceActions> _service2;
  StreamSubscription _streamSubscription2;
  S2 _lastStream2State;

  Service<S3, ServiceActions> _service3;
  StreamSubscription _streamSubscription3;
  S3 _lastStream3State;

  final StateBuilder3Callback<S1, S2, S3> builder;

  StateBuilder3State(
      this._service1, this._service2, this._service3, this.builder) {
    _streamSubscription1 = _service1.stream.listen(_onData1);
    _streamSubscription2 = _service2.stream.listen(_onData2);
    _streamSubscription3 = _service3.stream.listen(_onData3);

    // supply initial state to initial builder call
    _lastStream1State = _service1.makeInitialState();
    _lastStream2State = _service2.makeInitialState();
    _lastStream3State = _service3.makeInitialState();
  }

  _onData1(S1 state) {
    setState(() => _lastStream1State = state);
  }

  _onData2(S2 state) {
    setState(() => _lastStream2State = state);
  }

  _onData3(S3 state) {
    setState(() => _lastStream3State = state);
  }

  @override
  Widget build(BuildContext context) {
    return builder(
        context, _lastStream1State, _lastStream2State, _lastStream3State);
  }

  @override
  void dispose() {
    _streamSubscription1.cancel();
    _streamSubscription2.cancel();
    _streamSubscription3.cancel();

    super.dispose();
  }
}
