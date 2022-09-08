import 'package:flutter/cupertino.dart';

abstract class Model {
  @protected
  Map<String, dynamic> toMap() => {};
  @protected
  Map<String, dynamic> get data => toMap();
  @protected
  getValue(String key) => (data)[key];
}
