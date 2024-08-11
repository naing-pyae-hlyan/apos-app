import 'package:apos_app/lib_exp.dart';

const _orderErrorKey = "order-error-key";

class SubmitOrderPage extends StatefulWidget {
  const SubmitOrderPage({super.key});

  @override
  State<SubmitOrderPage> createState() => _SubmitOrderPageState();
}

class _SubmitOrderPageState extends State<SubmitOrderPage> {
  late CartBloc cartBloc;
  late OrderBloc orderBloc;
  late ErrorBloc errorBloc;
  final commentTxtCtrl = TextEditingController();

  void _onOrder() {
    final CustomerModel? customer = CacheManager.currentCustomer;
    if (customer == null) return;
    final String orderId = RandomIdGenerator.generateUniqueId();
    final order = OrderModel(
      readableId: orderId,
      customer: customer,
      items: cartBloc.items,
      orderDate: DateTime.now(),
      totalAmount: cartBloc.totalItemsAmount,
      statusId: 0,
      status: OrderStatus.newOrder,
      comment: commentTxtCtrl.text,
    );

    orderBloc.add(OrderEventSubmitOrder(order: order));
  }

  void _orderStateListener(BuildContext context, OrderState state) {
    if (state is OrderStateFail) {
      errorBloc.add(ErrorEventSetError(
        errorKey: _orderErrorKey,
        error: state.error,
      ));
    }

    if (state is OrderStateSubmitSuccess) {
      showSuccessDialog(
        context,
        message: "Your orders is submitted!",
        onTapOk: () {
          // close current page
          cartBloc.add(CartEventResetItems());
          context.pop(result: true);
        },
      );
    }
  }

  @override
  void initState() {
    cartBloc = context.read<CartBloc>();
    orderBloc = context.read<OrderBloc>();
    errorBloc = context.read<ErrorBloc>();
    super.initState();

    doAfterBuild(callback: () {
      errorBloc.add(ErrorEventResert());
    });
  }

  @override
  void dispose() {
    if (mounted) {
      commentTxtCtrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: myAppBar(title: myTitle("Submit Orders"), elevation: 0),
      padding: EdgeInsets.zero,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Divider(color: Colors.grey[300], thickness: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _itemRow(
                      qty: myTitle("Qty"),
                      item: myTitle("Items"),
                      amount: myTitle("Amount", textAlign: TextAlign.end),
                    ),
                  ),
                  Divider(color: Colors.grey[300], thickness: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) => _item(cartBloc.items[index]),
                    separatorBuilder: (_, __) => const Divider(thickness: 0.3),
                    itemCount: cartBloc.items.length,
                  ),
                  verticalHeight24,
                  Container(
                    color: Colors.grey[300],
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        myTitle("Total Payable:", color: Consts.primaryColor),
                        myTitle(
                          cartBloc.totalItemsAmount
                              .toCurrencyFormat(countryIso: "MMK"),
                          color: Consts.currencyGreen,
                        ),
                      ],
                    ),
                  ),
                  verticalHeight24,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: MyInputField(
                      controller: commentTxtCtrl,
                      errorKey: _orderErrorKey,
                      title: "Note (Options)",
                      hintText: "Enter your message here.",
                      maxLines: 4,
                    ),
                  ),
                  verticalHeight24,
                ],
              ),
            ),
          ),
          verticalHeight8,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: BlocConsumer<OrderBloc, OrderState>(
              builder: (_, state) {
                if (state is OrderStateLoading) {
                  return const MyCircularIndicator();
                }

                return MyButton(
                  label: "Order",
                  onPressed: _onOrder,
                  fitWidth: true,
                  icon: Icons.shopping_cart_checkout,
                );
              },
              listener: _orderStateListener,
            ),
          ),
          verticalHeight8,
        ],
      ),
    );
  }

  Widget _item(ItemModel item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _itemRow(
        qty: myText("${item.qty}", textAlign: TextAlign.center),
        item: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            myText(item.name, fontWeight: FontWeight.w700),
            if (item.product?.description?.isNotEmpty == true)
              myText(
                item.product?.description,
                color: Consts.descriptionColor,
                fontSize: 12,
              ),
            if (item.types.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  myText("Type:", fontSize: 12, color: Consts.descriptionColor),
                  myText(
                    item.types.join(","),
                    fontSize: 12,
                    color: Consts.descriptionColor,
                  ),
                ],
              ),
            if (item.colors.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  myText("Color", fontSize: 12, color: Consts.descriptionColor),
                  Wrap(
                    spacing: 8,
                    children: item.colors
                        .map((int color) => circularColor(color))
                        .toList(),
                  ),
                ],
              ),
          ],
        ),
        amount: myText(
          item.totalAmount.toCurrencyFormat(),
          textAlign: TextAlign.end,
        ),
      ),
    );
  }

  Widget _itemRow({
    required Widget qty,
    required Widget item,
    required Widget amount,
  }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(width: 48, child: qty),
          Expanded(child: item),
          SizedBox(width: 96, child: amount),
        ],
      );
}
