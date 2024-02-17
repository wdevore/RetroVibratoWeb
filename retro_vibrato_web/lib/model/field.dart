import 'package:flutter/foundation.dart';

class Field with ChangeNotifier {
  double min = 0.0;
  double max = 1.0;

  dynamic _value = 0;
  dynamic rValue = 0;

  String label = "";

  Field(this.min, this.max, this._value, this.label) {
    rValue = _value;
  }
  Field.noRange(this._value, this.label) {
    rValue = _value;
  }

  set value(dynamic v) {
    _value = v;
    notifyListeners();
  }

  dynamic get value => _value;

  reset() {
    value = rValue;
  }

  void update() {
    notifyListeners();
  }
}
