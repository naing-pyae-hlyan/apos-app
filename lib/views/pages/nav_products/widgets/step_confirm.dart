import 'package:apos_app/lib_exp.dart';

class StepConfirm extends StatefulWidget {
  final List<ItemModel> items;
  final int totalItemsAmount;
  final String payBy;
  final String? base64PaymentSS;
  final Function() onTapBack;
  const StepConfirm({
    super.key,
    required this.items,
    required this.totalItemsAmount,
    required this.base64PaymentSS,
    required this.payBy,
    required this.onTapBack,
  });

  @override
  State<StepConfirm> createState() => _StepConfirmState();
}

class _StepConfirmState extends State<StepConfirm> {
  late CartBloc cartBloc;
  late OrderBloc orderBloc;

  final commentTxtCtrl = TextEditingController();

  void _onOrder() {
    final CustomerModel? customer = CacheManager.currentCustomer;
    if (customer == null) return;
    final String orderId = RandomIdGenerator.generateUniqueId();
    showConfirmDialog(
      context,
      title: "Order Submition",
      description: "Are you sure want to submit order?",
      okLabel: "Submit",
      icon: const Icon(
        Icons.shopping_cart_checkout,
        size: 96,
        color: Consts.primaryColor,
      ),
      okColor: Consts.primaryColor,
      onTapOk: () async {
        final order = OrderModel(
          readableId: orderId,
          customer: customer,
          items: widget.items,
          orderDate: DateTime.now(),
          totalAmount: widget.totalItemsAmount,
          statusId: 0,
          status: OrderStatus.newOrder,
          comment: commentTxtCtrl.text,
          payment: widget.payBy,
          paymentSS: widget.base64PaymentSS,
        );

        orderBloc.add(OrderEventSubmitOrder(order: order));
      },
    );
  }

  void _orderStateListener(BuildContext context, OrderState state) {
    if (state is OrderStateFail) {
      showErrorDialog(
        context,
        title: "",
        onTapOk: () {
          orderBloc.add(OrderEventStopLoading());
        },
      );
    }
    if (state is OrderStateSubmitSuccess) {
      showSuccessDialog(
        context,
        message: "Your orders is submitted!",
        onTapOk: () {
          cartBloc.add(CartEventResetItems());
          context.pop(result: true);
        },
      );
    }
  }

  @override
  void initState() {
    orderBloc = context.read<OrderBloc>();
    cartBloc = context.read<CartBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyStep(
      bottomNavigationBar: BlocConsumer<OrderBloc, OrderState>(
        listener: _orderStateListener,
        builder: (_, state) {
          if (state is OrderStateLoading) {
            return const MyCircularIndicator();
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: MyButton(
                  label: "Payment",
                  icon: Icons.arrow_back,
                  backgroundColor: Consts.secondaryColor,
                  labelColor: Consts.primaryColor,
                  onPressed: widget.onTapBack,
                ),
              ),
              horizontalWidth12,
              Expanded(
                child: MyButton(
                  label: "Submit",
                  icon: Icons.shopping_cart_checkout,
                  onPressed: _onOrder,
                ),
              ),
            ],
          );
        },
      ),
      children: [
        Container(
          color: Colors.grey[300],
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              myTitle("Receipt"),
              myText(DateTime.now().toDDmmYYYYHHmm()),
            ],
          ),
        ),
        verticalHeight8,
        centerRight(
          myText(CacheManager.currentCustomer?.name),
        ),
        verticalHeight2,
        centerRight(myText(CacheManager.currentCustomer?.phone)),
        verticalHeight2,
        centerRight(
          myText(
            CacheManager.currentCustomer?.address,
            maxLines: 4,
          ),
        ),
        verticalHeight8,
        const MySeparator(),
        verticalHeight8,
        tableRow(
          item: myTitle("Items"),
          qty: myTitle("Qty"),
          amount: myTitle("Amount", textAlign: TextAlign.end),
        ),
        verticalHeight8,
        const MySeparator(),
        verticalHeight8,
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) => productItem(widget.items[index]),
          separatorBuilder: (_, __) => verticalHeight8,
          itemCount: widget.items.length,
        ),
        verticalHeight8,
        const MySeparator(),
        verticalHeight8,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            myTitle("Total:"),
            SizedBox(
              width: 120,
              child: myTitle(
                widget.totalItemsAmount.toCurrencyFormat(),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        verticalHeight8,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            myTitle("Pay By:"),
            SizedBox(
              width: 120,
              child: myTitle(
                widget.payBy,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        verticalHeight16,
        MyInputField(
          controller: commentTxtCtrl,
          hintText: "Enter your message here",
          title: "Note (Optional)",
          errorKey: null,
          maxLines: 4,
        ),
        verticalHeight24,
      ],
    );
  }

  Widget productItem(ItemModel item) {
    return tableRow(
      qty: myText("${item.qty}", textAlign: TextAlign.center),
      item: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          myText(item.name, fontWeight: FontWeight.w600),
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
    );
  }

  Align centerRight(Widget child) => Align(
        alignment: Alignment.centerRight,
        child: child,
      );

  Widget tableRow({
    required Widget qty,
    required Widget item,
    required Widget amount,
  }) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(child: item),
          SizedBox(width: 48, child: qty),
          SizedBox(width: 96, child: amount),
        ],
      );
}
