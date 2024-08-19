import 'package:apos_app/lib_exp.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductModel product;
  final ItemModel? item;
  const ProductDetailsPage({
    super.key,
    required this.product,
    this.item,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final ValueNotifier<num> _itemPricingListener = ValueNotifier(0.0);
  int _itemQty = 1;
  String? _selectedType;
  int? _selectedColor;
  late CartBloc cartBloc;
  late DbBloc dbBloc;

  void addToCart() {
    final item = ItemModel(
      id: widget.product.id!,
      name: widget.product.name,
      price: widget.product.price,
      types: _selectedType == null ? [] : [_selectedType!],
      colors: _selectedColor == null ? [] : [_selectedColor!],
      qty: _itemQty,
      totalAmount: _itemPricingListener.value,
      product: widget.product,
    );

    if (widget.item == null) {
      // add to cart
      cartBloc.add(CartEventAddItem(item: item));
    } else {
      // update to cart
      cartBloc.add(CartEventUpdateItem(item: item));
    }

    // Close the ProductDetailsPage
    context.pop(result: true);
  }

  @override
  void initState() {
    cartBloc = context.read<CartBloc>();
    dbBloc = context.read<DbBloc>();
    super.initState();
    if (widget.item != null) {
      _itemQty = widget.item?.qty ?? 1;
      if (widget.item?.types.isNotEmpty == true) {
        _selectedType = widget.item?.types.first;
      }
      if (widget.item?.colors.isNotEmpty == true) {
        _selectedColor = widget.item?.colors.first;
      }
    }
    doAfterBuild(callback: () {
      _itemPricingListener.value = widget.product.price * _itemQty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: myAppBar(
        title: myTitle(widget.product.name),
        actions: [
          BlocBuilder<DbBloc, DbState>(
            builder: (_, state) {
              if (state is DbStateLoading) {
                return emptyUI;
              }
              return FutureBuilder<bool>(
                future: SpHelper.itemIsFav(
                  widget.product.categoryId,
                  widget.product.id,
                ),
                builder: (context, snapshot) {
                  final bool isFav = snapshot.data ?? false;
                  return IconButton(
                    onPressed: () {
                      if (widget.product.categoryId != null &&
                          widget.product.id != null) {
                        dbBloc.add(DbEventUpdateFavItem(
                          categoryId: widget.product.categoryId!,
                          productId: widget.product.id!,
                          isFav: !isFav,
                        ));
                      }
                    },
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: Consts.primaryColor,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      padding: EdgeInsets.zero,
      fab: floatingActionButton(
        onPressed: addToCart,
        iconData: widget.item == null ? Icons.add_shopping_cart : Icons.save,
        heroTag: heroTagCart,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            verticalHeight8,
            SwipeableImages(
              base64Images: widget.product.base64Images,
              heroTag: widget.product.readableId,
            ),
            verticalHeight16,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                horizontalWidth20,
                const Icon(
                  Icons.shopping_cart_checkout,
                  color: Consts.primaryColor,
                ),
                horizontalWidth4,
                myText("Shopping", color: Consts.primaryColor),
              ],
            ),
            verticalHeight8,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: myTitle(
                widget.product.name,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (widget.product.description?.isNotEmpty == true) ...[
              verticalHeight4,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: myText(
                  widget.product.description,
                  color: Consts.descriptionColor,
                  maxLines: 100,
                ),
              ),
            ],
            verticalHeight8,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: myTitle(
                widget.product.price.toCurrencyFormat(countryIso: "MMK"),
                fontWeight: FontWeight.w700,
              ),
            ),
            verticalHeight8,
            const Divider(thickness: 0.5),
            if (widget.product.sizes.isNotEmpty) ...[
              verticalHeight8,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: MultiSelectProductSizes(
                  sizes: widget.product.sizes,
                  oldSizes: widget.item?.types ?? [],
                  onSelectedSize: (String? selectedSize) {
                    _selectedType = selectedSize;
                  },
                ),
              ),
            ],
            if (widget.product.hexColors.isNotEmpty) ...[
              verticalHeight8,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: MultiSelectProductColors(
                  hexColors: widget.product.hexColors,
                  oldHexColors: widget.item?.colors ?? [],
                  onSelectedColors: (int? selectedColor) {
                    _selectedColor = selectedColor;
                  },
                ),
              ),
            ],
            verticalHeight8,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: QtyButton(
                qty: widget.item?.qty,
                onQtyChanged: (int qty) {
                  _itemQty = qty;
                  _itemPricingListener.value = widget.product.price * qty;
                },
              ),
            ),
            verticalHeight24,
            Container(
              padding: const EdgeInsets.all(16),
              color: Consts.secondaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  myTitle(
                    "Total Payable",
                    color: Consts.descriptionColor,
                    fontWeight: FontWeight.w600,
                  ),
                  ValueListenableBuilder<num>(
                    valueListenable: _itemPricingListener,
                    builder: (_, num value, ___) {
                      return myTitle(
                        "$value".toCurrencyFormat(countryIso: "MMK"),
                        fontWeight: FontWeight.w700,
                      );
                    },
                  ),
                ],
              ),
            ),
            verticalHeight128,
          ],
        ),
      ),
    );
  }
}
