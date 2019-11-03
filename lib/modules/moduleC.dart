import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:state_library_app/utils/crud/service.dart';
import 'package:state_library_app/utils/crud/service_action.dart';
import 'package:state_library_app/utils/crud/service_action_builder.dart';
import 'package:state_library_app/utils/crud/service_actions.dart';
import 'package:state_library_app/utils/crud/service_state.dart';

import 'autoload.dart';
import 'moduleA.dart';

class ModuleCActions extends ServiceActions {
  ActionBuilder<int> get setValue =>
      new ActionBuilder(prefix, 'SET_VALUE', 'OK');

  ModuleCActions(String prefix) : super(prefix);
}

class ModuleCState extends ServiceState {
  final int value;

  ModuleCState(this.value);

  ModuleCState copy({int value}) {
    return new ModuleCState(value);
  }
}

class ModuleC extends Service<ModuleCState, ModuleCActions> {
  ModuleC(String name) : super(name) {
    actions = new ModuleCActions(name);
    main();
  }

  makeInitialState() {
    return new ModuleCState(null);
  }

  reducer(ModuleCState state, ServiceAction action) {
    // How to make it like:
    // if (action is SetValueAction) {
    if (action.type == actions.setValue.type) {
      return state.copy(value: action.payload);
    }

    return state;
  }

  main() async {
    await watchForModuleA();
  }

  watchForModuleA() async {
    final stream = combineAll([moduleA.stream, moduleB.stream]);

    await for (var s in stream) {
      ModuleAState a1 = s[0];
      ModuleAState a2 = s[1];

      int newValue = a1.value + a2.value;
      actions.setValue.dispatch(newValue);
    }
  }
}

final Map<String, StreamController> streamMap = {};

Stream combineAll(Iterable<Stream> streams) {
  // generate combined stream id from input streams id so we
  // keep only one instance for particular input list
  final streamId = streams.map((s) => s.hashCode).join(',');

  // check if these streams already were combined and use that instance
  if (streamMap[streamId] is StreamController) {
    return streamMap[streamId].stream;
  }

  final List lastEvents = List.filled(streams.length, null);
  final List<bool> doneStreams = List.filled(streams.length, false);

  final streamController = new StreamController.broadcast();
  streamMap[streamId] = streamController;

  listenToStreamAndUpdate(Stream s, int i) {
    onData(event) {
      lastEvents[i] = event;

      streamController.add(lastEvents);
    }

    onDone() {
      doneStreams[i] = true;

      if (doneStreams.every((f) => f == true)) {
        // release reference so GC can clean up
        streamMap.remove(streamId);
        streamController.close();
      }
    }

    s.listen(onData, onDone: onDone);
  }

  int streamIndex = 0;
  for (Stream stream in streams) {
    listenToStreamAndUpdate(stream, streamIndex);
    streamIndex++;
  }

  return streamController.stream;
}


// =============================================================================
class ServiceBuilder extends StatefulWidget {
  final List<Service> services;
  final WidgetBuilder builder;

  ServiceBuilder({this.services, this.builder});

  @override
  State<StatefulWidget> createState() {
    return new ServiceBuilderState(services, builder);
  }
}

class ServiceBuilderState extends State {
  final List<Service> services;
  final WidgetBuilder builder;

  ServiceBuilderState(this.services, this.builder) {
    services.forEach((s) {
      s.stream.listen(_onData);
    });
  }

  _onData(_) {
    setState(() => null);
  }

  @override
  Widget build(BuildContext context) {
    return builder(context);
  }
}
