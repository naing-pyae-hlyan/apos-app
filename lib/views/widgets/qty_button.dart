import 'package:apos_app/lib_exp.dart';

class QtyButton extends StatefulWidget {
  final int? qty;
  final Function(int) onQtyChanged;
  final bool needTitle;
  const QtyButton({
    super.key,
    this.qty,
    this.needTitle = true,
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
    final buttons = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 28,
          height: 28,
          child: CircleAvatar(
            backgroundColor: Consts.primaryColor,
            child: Clickable(
              onTap: descreased,
              child: const Icon(Icons.remove, color: Colors.white),
            ),
          ),
        ),
        SizedBox(
          width: 48,
          child: myText("$_qty", textAlign: TextAlign.center),
        ),
        SizedBox(
          width: 28,
          height: 28,
          child: CircleAvatar(
            backgroundColor: Consts.primaryColor,
            child: Clickable(
              onTap: increased,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
      ],
    );
    if (widget.needTitle) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          myText("Quantity"),
          verticalHeight8,
          buttons,
        ],
      );
    }

    return buttons;
  }
}
