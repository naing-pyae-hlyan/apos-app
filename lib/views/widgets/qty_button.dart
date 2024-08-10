import 'package:apos_app/lib_exp.dart';

class QtyButton extends StatefulWidget {
  final int? qty;
  final Function(int) onQtyChanged;
  const QtyButton({
    super.key,
    this.qty,
    required this.onQtyChanged,
  });

  @override
  State<QtyButton> createState() => _QtyButtonState();
}

class _QtyButtonState extends State<QtyButton> {
  int _qty = 1;

  void increased() {
    setState(() {
      _qty++;
    });
    widget.onQtyChanged(_qty);
  }

  void descreased() {
    if (_qty <= 1) return;
    setState(() {
      _qty--;
    });
    widget.onQtyChanged(_qty);
  }

  @override
  void initState() {
    _qty = widget.qty ?? 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        myText("Quantity"),
        verticalHeight8,
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: Consts.primaryColor,
              child: IconButton(
                onPressed: descreased,
                icon: const Icon(Icons.remove, color: Colors.white),
              ),
            ),
            SizedBox(
              width: 48,
              child: myText("$_qty", textAlign: TextAlign.center),
            ),
            CircleAvatar(
              backgroundColor: Consts.primaryColor,
              child: IconButton(
                onPressed: increased,
                icon: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
