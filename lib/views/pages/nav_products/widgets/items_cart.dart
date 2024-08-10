import 'package:apos_app/lib_exp.dart';

class ItemCart extends StatefulWidget {
  const ItemCart({super.key});

  @override
  State<ItemCart> createState() => _ItemCartState();
}

class _ItemCartState extends State<ItemCart> {
  late CartBloc cartBloc;

  @override
  void initState() {
    cartBloc = context.read<CartBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (_, state) {
        if (cartBloc.items.isEmpty) {
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
                    myText(
                      "Qty",
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                    myText("${cartBloc.totalItemsQty}", color: Colors.white),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    myText(
                      "Total",
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                    myText("${cartBloc.totalItemsAmount}".toCurrencyFormat(),
                        color: Colors.white),
                  ],
                ),
                Hero(
                  tag: heroTagCart,
                  child: IconButton(
                    onPressed: () => context.push(const OrderSummaryPage()),
                    highlightColor: Colors.black12,
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
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
