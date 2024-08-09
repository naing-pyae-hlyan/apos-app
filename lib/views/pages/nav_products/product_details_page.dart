// import 'package:apos_app/lib_exp.dart';

// class ProductDetailsPage extends StatefulWidget {
//   final ProductModel product;
//   const ProductDetailsPage({
//     super.key,
//     required this.product,
//   });

//   @override
//   State<ProductDetailsPage> createState() => _ProductDetailsPageState();
// }

// class _ProductDetailsPageState extends State<ProductDetailsPage> {
//   final ValueNotifier<double> _itemPricingListener = ValueNotifier(0.0);
//   int _itemQty = 1;
//   String? _selectedClothSize;
//   String? _selectedShoesize;
//   String? _selectedColor;
//   late OrdersBloc itemsBloc;

//   void addToCart() {
//     final item = ItemModel.addItem(
//       product: widget.product,
//       q: _itemQty,
//       tp: _itemPricingListener.value,
//       color: parseProductColorNameToHex(_selectedColor),
//       sizeForCloth: _selectedClothSize,
//       sizeForShoe: _selectedShoesize,
//     );
//     itemsBloc.add(OrdersEventAddItem(item: item));

//     // Close the ProductDetailsPage
//     context.pop();
//   }

//   @override
//   void initState() {
//     itemsBloc = context.read<OrdersBloc>();
//     super.initState();
//     doAfterBuild(callback: () {
//       _itemPricingListener.value = widget.product.price;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MyScaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: true,
//         title: myTitle(widget.product.name),
//         elevation: 0,
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.white,
//         shadowColor: Consts.secondaryColor,
//       ),
//       padding: EdgeInsets.zero,
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.start,
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             verticalHeight8,
//             SwipeableImages(
//               base64Images: widget.product.base64Images,
//               heroTag: widget.product.readableId,
//             ),
//             verticalHeight24,
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 horizontalWidth20,
//                 const Icon(
//                   Icons.shopping_cart_checkout,
//                   color: Consts.primaryColor,
//                 ),
//                 horizontalWidth4,
//                 myText("Shopping", color: Consts.primaryColor),
//               ],
//             ),
//             verticalHeight16,
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: myTitle(widget.product.name),
//             ),
//             verticalHeight4,
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: myText(
//                 widget.product.description,
//                 color: Consts.descriptionColor,
//                 maxLines: 100,
//               ),
//             ),
//             verticalHeight16,
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: myTitle(
//                 widget.product.price.toCurrencyFormat(countryIso: "MMK"),
//               ),
//             ),
//             const Divider(thickness: 0.5),
//             if (widget.product.clothSizes.isNotEmpty) ...[
//               verticalHeight8,
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: MultiSelectProductSizes(
//                   sizes: widget.product.clothSizes,
//                   oldSizes: const [],
//                   onSelectedSize: (String selectedSize) {
//                     _selectedClothSize = selectedSize;
//                   },
//                 ),
//               ),
//             ],
//             if (widget.product.shoeSizes.isNotEmpty) ...[
//               verticalHeight8,
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: MultiSelectProductSizes(
//                   sizes: widget.product.shoeSizes,
//                   oldSizes: const [],
//                   onSelectedSize: (String selectedSize) {
//                     _selectedShoesize = selectedSize;
//                   },
//                 ),
//               ),
//             ],
//             if (widget.product.hexColors.isNotEmpty) ...[
//               verticalHeight8,
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24),
//                 child: MultiSelectProductColors(
//                   productColors: widget.product.productColorsEnum,
//                   oldHexColors: const [],
//                   onSelectedColors: (String selectedColor) {
//                     _selectedColor = selectedColor;
//                   },
//                 ),
//               ),
//             ],
//             verticalHeight24,
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: QtyButton(
//                 onQtyChanged: (int qty) {
//                   _itemQty = qty;
//                   _itemPricingListener.value = widget.product.price * qty;
//                 },
//               ),
//             ),
//             verticalHeight24,
//             Container(
//               padding: const EdgeInsets.all(16),
//               color: Consts.secondaryColor,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   myTitle("Total Payable", color: Consts.descriptionColor),
//                   ValueListenableBuilder(
//                     valueListenable: _itemPricingListener,
//                     builder: (_, double value, ___) {
//                       return myTitle(
//                         "$value".toCurrencyFormat(countryIso: "MMK"),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             verticalHeight24,
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: MyButton(
//                 label: "Add to cart",
//                 icon: Icons.shopping_cart,
//                 fitWidth: true,
//                 onPressed: addToCart,
//               ),
//             ),
//             verticalHeight24,
//           ],
//         ),
//       ),
//     );
//   }
// }
