import 'package:apos_app/lib_exp.dart';

class MultiSelectProductSizes extends StatefulWidget {
  final List<String> sizes;
  final List<String> oldSizes;
  final Function(String?) onSelectedSize;
  const MultiSelectProductSizes({
    super.key,
    required this.sizes,
    required this.oldSizes,
    required this.onSelectedSize,
  });

  @override
  State<MultiSelectProductSizes> createState() =>
      _MultiSelectProductSizesState();
}

class _MultiSelectProductSizesState extends State<MultiSelectProductSizes> {
  final List<String> selectedSizes = [];

  List<Widget> _buildSizeList() {
    List<Widget> choices = [];
    for (final String size in widget.sizes) {
      choices.add(
        ChoiceChip(
          label: myText(size),
          selected: selectedSizes.contains(size),
          onSelected: (bool selected) {
            setState(() {
              if (selectedSizes.contains(size)) {
                selectedSizes.remove(size);
              } else {
                selectedSizes.clear();
                selectedSizes.add(size);
              }
            });
            if (selectedSizes.isEmpty) {
              widget.onSelectedSize(null);
            } else {
              widget.onSelectedSize(selectedSizes.first);
            }
          },
        ),
      );
    }

    return choices;
  }

  @override
  void initState() {
    selectedSizes.clear();
    selectedSizes.addAll(widget.oldSizes);
    super.initState();
  }

  @override
  void dispose() {
    selectedSizes.clear();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MultiSelectProductSizes oldWidget) {
    selectedSizes.clear();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        myText("Types"),
        verticalHeight4,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _buildSizeList(),
        ),
      ],
    );
  }
}
