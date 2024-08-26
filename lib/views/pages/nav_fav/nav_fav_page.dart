import 'package:apos_app/lib_exp.dart';

class NavFavPage extends StatefulWidget {
  const NavFavPage({super.key});

  @override
  State<NavFavPage> createState() => _NavFavPageState();
}

class _NavFavPageState extends State<NavFavPage> {
  late DbBloc dbBloc;
  double itemWidth = 120;

  @override
  void initState() {
    dbBloc = context.read<DbBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    itemWidth = context.screenWidth * 0.3 - 8;
    return MyScaffold(
      padding: EdgeInsets.zero,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalHeight8,
                  myTitle("My Favorites", color: Consts.primaryColor),
                  BlocBuilder<DbBloc, DbState>(
                    builder: (_, state) {
                      if (state is DbStateLoading) {
                        return const Center(
                          child: MyCircularIndicator(),
                        );
                      }

                      return FutureBuilder(
                        future: SpHelper.favItems,
                        builder: (_, snapshot) {
                          if (CacheManager.categories.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 32),
                                child: myText("No favorite items"),
                              ),
                            );
                          }
                          if (CacheManager.products.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 32),
                                child: myText("No favorite items"),
                              ),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: MyCircularIndicator(),
                            );
                          }
                          final data = snapshot.data ?? {};

                          if (data.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 32),
                                child: myText("No favorite items"),
                              ),
                            );
                          }

                          final categoryIds = data.keys.toList();
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: categoryIds.length,
                            separatorBuilder: (_, __) => verticalHeight8,
                            itemBuilder: (_, index) {
                              final categoryId = categoryIds[index];
                              final List<String> productIds =
                                  data[categoryId] ?? [];
                              if (productIds.isEmpty) return emptyUI;
                              return _listTile(categoryId, productIds);
                            },
                          );
                        },
                      );
                    },
                  ),
                  verticalHeight128,
                ],
              ),
            ),
          ),
          const ItemCart(),
        ],
      ),
    );
  }

  Widget _listTile(String categoryId, List<String> itemIds) {
    if (CacheManager.categories.isEmpty) return emptyUI;
    CategoryModel? category;
    for (final CategoryModel cm in CacheManager.categories) {
      if (cm.id == categoryId) {
        category = cm;
        break;
      }
    }

    if (category == null) return emptyUI;
    final List<ProductModel> products = [];
    if (CacheManager.products.isEmpty) return emptyUI;
    for (String id in itemIds) {
      for (ProductModel pm in CacheManager.products) {
        if (pm.id == id) {
          products.add(pm);
          break;
        }
      }
    }

    if (products.isEmpty) return emptyUI;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalHeight16,
        myTitle(category.name, maxLines: 2),
        verticalHeight8,
        MyCard(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 8,
          ),
          child: SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.start,
              children: products
                  .map((ProductModel product) => ProductItem(
                        itemWidth: itemWidth,
                        product: product,
                        isFav: true,
                        onPressed: () {
                          context.push(
                            ProductDetailsPage(product: product),
                          );
                        },
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
