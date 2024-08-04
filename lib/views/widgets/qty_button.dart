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
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Consts.primaryColor,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          // width: 120,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: descreased,
                icon: const Icon(Icons.remove, color: Consts.primaryColor),
                color: Consts.primaryColor,
              ),
              Container(
                width: 100,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Consts.secondaryColor),
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                child: myTitle('$_qty'),
              ),
              IconButton(
                onPressed: increased,
                icon: const Icon(Icons.add, color: Consts.primaryColor),
                color: Consts.primaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
