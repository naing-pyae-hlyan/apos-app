import 'package:apos_app/lib_exp.dart';

class MoreProductsPage extends StatefulWidget {
  final CategoryModel category;
  final List<ProductModel> products;
  const MoreProductsPage({
    super.key,
    required this.category,
    required this.products,
  });

  @override
  State<MoreProductsPage> createState() => _MoreProductsPageState();
}

class _MoreProductsPageState extends State<MoreProductsPage> {
  late CartBloc cartBloc;
  double itemWidth = 120;

  final searchTxtCtrl = TextEditingController();

  final ValueNotifier<String> searchCtrl = ValueNotifier("");

  void _navigateToOrderSummaryPage() async {
    final result = await context.push(const OrderSummaryPage());
    if (mounted && result == true) {
      context.pop();
    }
  }

  @override
  void initState() {
    cartBloc = context.read<CartBloc>();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      searchTxtCtrl.dispose();
    }
    super.dispose();
  }

  Widget? home;
  @override
  Widget build(BuildContext context) {
    itemWidth = context.screenWidth * 0.3 - 4;
    home ??= MyScaffold(
      appBar: _myAppBar(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalHeight8,
          MyInputField(
            controller: searchTxtCtrl,
            errorKey: null,
            hintText: "Search",
            onChanged: (String query) {
              searchCtrl.value = query;
              if (query.isEmpty) {
                context.hideKeyboard();
              }
            },
            onSubmitted: (String query) {
              searchCtrl.value = query;
              if (query.isEmpty) {
                context.hideKeyboard();
              }
            },
          ),
          verticalHeight8,
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: searchCtrl,
              builder: (_, String value, __) {
                final List<ProductModel> search = [];

                if (value.isNotEmpty) {
                  for (var product in widget.products) {
                    if (stringCompare(product.name, value)) {
                      search.add(product);
                    }
                  }
                }

                return _items(search.isEmpty ? widget.products : search);
              },
            ),
          ),
          verticalHeight8,
        ],
      ),
    );

    return home!;
  }

  AppBar _myAppBar() => myAppBar(
        title: myTitle(widget.category.name),
        centerTitle: false,
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (_, state) {
              if (cartBloc.items.isEmpty) return emptyUI;
              return Clickable(
                onTap: _navigateToOrderSummaryPage,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Hero(
                      tag: heroTagCart,
                      child: IconButton(
                        onPressed: _navigateToOrderSummaryPage,
                        highlightColor: Colors.black12,
                        icon: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Consts.primaryColor,
                        ),
                      ),
                    ),
                    circularCount(cartBloc.totalItemsQty),
                  ],
                ),
              );
            },
          ),
        ],
      );

  Widget _items(List<ProductModel> products) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.start,
          children: products.map(
            (ProductModel product) {
              return ProductItem(
                key: UniqueKey(),
                itemWidth: itemWidth,
                product: product,
                onPressed: () {
                  context.hideKeyboard();
                  context.push(ProductDetailsPage(product: product));
                },
              );
            },
          ).toList(),
        ),
      );
}
