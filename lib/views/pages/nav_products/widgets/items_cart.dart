import 'package:apos_app/lib_exp.dart';

class ItemCart extends StatefulWidget {
  const ItemCart({super.key});

  @override
  State<ItemCart> createState() => _ItemCartState();
}

class _ItemCartState extends State<ItemCart> {
  late OrdersBloc itemsBloc;

  @override
  void initState() {
    itemsBloc = context.read<OrdersBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (_, state) {
        if (itemsBloc.items.isEmpty) {
          return emptyUI;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: MyCard(
            cardColor: Consts.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    myTitle("Qty", color: Colors.white),
                    myText("${itemsBloc.itemsQty}", color: Colors.white),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    myTitle("Total", color: Colors.white),
                    myText("${itemsBloc.itemsTotalPrice}".toCurrencyFormat(),
                        color: Colors.white),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  highlightColor: Colors.black12,
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
