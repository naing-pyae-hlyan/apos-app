import 'package:apos_app/lib_exp.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;
  const ProductDetailsPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: myTitle(widget.product.name),
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Consts.secondaryColor,
      ),
      padding: EdgeInsets.zero,
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
            verticalHeight24,
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
            verticalHeight16,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: myTitle(widget.product.name),
            ),
            verticalHeight4,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: myText(
                widget.product.description,
                color: Consts.descriptionColor,
                maxLines: 100,
              ),
            ),
            const Divider(thickness: 0.5),
            if (widget.product.sizes.isNotEmpty) ...[
              verticalHeight8,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: MultiSelectProductSizes(
                  sizes: widget.product.sizes,
                  oldSizes: const [],
                  onSelectedSize: (String selectedSize) {},
                ),
              ),
            ],
            if (widget.product.hexColors.isNotEmpty) ...[
              verticalHeight8,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: MultiSelectProductColors(
                  productColors: widget.product.productColorsEnum,
                  oldHexColors: const [],
                  onSelectedColors: (String selectedColor) {},
                ),
              ),
            ],
            verticalHeight24,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: myTitle(
                widget.product.price.toCurrencyFormat(countryIso: "MMK"),
              ),
            ),
            verticalHeight64,
          ],
        ),
      ),
    );
  }
}
