import 'package:apos_app/lib_exp.dart';

class ItemsAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ItemsAppBar({super.key});

  @override
  State<ItemsAppBar> createState() => _ItemsAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 32);
}

class _ItemsAppBarState extends State<ItemsAppBar> {
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

        return MyCard(
          cardColor: Consts.primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  myTitle("Qty", color: Colors.white),
                  myText("${itemsBloc.itemsQty}", color: Colors.white),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  myTitle("Total", color: Colors.white),
                  myText("${itemsBloc.itemsTotalPrice}".toCurrencyFormat(),
                      color: Colors.white),
                ],
              ),
              MyButton(
                label: "Continue",
                backgroundColor: Colors.white,
                labelColor: Consts.primaryColor,
                icon: Icons.shopping_cart,
                onPressed: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}
