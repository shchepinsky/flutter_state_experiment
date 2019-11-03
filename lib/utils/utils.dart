bool isNull (data) => data == null;

bool isNotNull (data) => data != null;

bool isEmpty(data) {
  if (isNull(data)) {
    return true;
  }

  if (data is String && data.trim().length == 0) {
    return true;
  }

  if (data is List && data.length == 0) {
    return true;
  }

  return false;
}