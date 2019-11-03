import 'service_action.dart';
import 'service_action_bus.dart';

class ActionBuilder<T> {
  static const PREFIX_DELIMITER = '/';
  static const SUFFIX_DELIMITER = ':';

  static String makeType ([String service, String action, String suffix]) {
    if (action == null || action.length < 1) {
      throw new ArgumentError.value(action, 'name', 'must be non empty string');
    }

    bool isNotEmpty (String s) => s != null && s.length > 0;

    final parts = [
      if (isNotEmpty(service)) service,
      if (isNotEmpty(service)) PREFIX_DELIMITER,
      action,
      if (isNotEmpty(suffix)) SUFFIX_DELIMITER,
      if (isNotEmpty(suffix)) suffix,
    ];

    return parts.join();
  }

  final String prefix;
  final String action;
  final String suffix;

  ActionBuilder(this.prefix, this.action, [this.suffix]);

  String get type => makeType(prefix, action, suffix);

  ServiceAction<T> build(T payload) {
    return new ServiceAction(type, payload);
  }

  dispatch(T payload) {
    final ServiceAction<T> action = new ServiceAction(type, payload);
    actionBus.put(action);
  }
}