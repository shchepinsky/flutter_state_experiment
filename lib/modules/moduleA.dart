import 'package:state_library_app/utils/crud/service.dart';
import 'package:state_library_app/utils/crud/service_action.dart';
import 'package:state_library_app/utils/crud/service_action_builder.dart';
import 'package:state_library_app/utils/crud/service_actions.dart';
import 'package:state_library_app/utils/crud/service_state.dart';

class ModuleAActions extends ServiceActions {
  ActionBuilder<void> get increment => new ActionBuilder(prefix, 'INCREMENT');

  ModuleAActions(String prefix) : super(prefix);
}

class ModuleAState extends ServiceState {
  final int value;
  final String data;

  ModuleAState(this.value, this.data);

  ModuleAState copy({int count, String data}) {
    return new ModuleAState(count, data);
  }
}

class ModuleA extends Service<ModuleAState, ModuleAActions> {
  ModuleA(String name) : super(name) {
    actions = new ModuleAActions(name);
  }

  makeInitialState() {
    // TODO: implement makeInitialState
    return new ModuleAState(0, null);
  }

  reducer(ModuleAState state, ServiceAction action) {
    if (action.type == actions.increment.type) {
      return state.copy(count: state.value + 1);
    }

    return state;
  }
}
