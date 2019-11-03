import 'dart:convert';

class ServiceAction<T> {
  final String type;
  final T payload;

  ServiceAction(this.type, [this.payload]);

  String toJSON () {
    final map = {
      'type': type,
      'payload': payload,
    };

    return jsonEncode(map);
  }
}
