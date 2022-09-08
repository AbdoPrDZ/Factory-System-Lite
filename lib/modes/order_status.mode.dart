import 'mode.dart';

class OrderStatus extends Mode<String> {
  const OrderStatus._(String mode) : super(mode);

  static const OrderStatus inProgress = OrderStatus._('In progress');
  static const OrderStatus waiting = OrderStatus._('Waiting');
  static const OrderStatus ended = OrderStatus._('Ended');
}
