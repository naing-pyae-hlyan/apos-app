import 'package:apos_app/lib_exp.dart';

enum OrderStatus {
  newOrder(
    code: 0,
    name: "New Order",
    value: "",
    color: Colors.indigo,
    icon: Icons.add,
  ),
  cancelled(
    code: 1,
    name: "Cancelled",
    value: "Cancel",
    color: Colors.grey,
    icon: Icons.cancel_rounded,
  ),
  processing(
    code: 2,
    name: "Processing",
    value: "Process",
    color: Colors.orange,
    icon: Icons.rocket_launch_rounded,
  ),
  delivered(
    code: 3,
    name: "Delivered",
    value: "Finish",
    color: Colors.green,
    icon: Icons.done_all,
  );

  final int code;
  final String name;
  final String value;
  final Color color;
  final IconData icon;
  const OrderStatus({
    required this.code,
    required this.name,
    required this.value,
    required this.color,
    required this.icon,
  });
}

OrderStatus parseToOrderStatus(int code) => code == 0
    ? OrderStatus.newOrder
    : code == 1
        ? OrderStatus.cancelled
        : code == 2
            ? OrderStatus.processing
            : OrderStatus.delivered;

OrderStatus parseToOrderStatusForMobileUI(int code) => code == 0
    ? OrderStatus.processing
    : code == 1
        ? OrderStatus.cancelled
        : code == 2
            ? OrderStatus.processing
            : OrderStatus.delivered;
