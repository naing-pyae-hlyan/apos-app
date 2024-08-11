import 'package:apos_app/lib_exp.dart';

class MultiSelectProductColors extends StatefulWidget {
  final List<int> hexColors;
  final List<int> oldHexColors;
  final Function(int?) onSelectedColors;
  const MultiSelectProductColors({
    super.key,
    required this.hexColors,
    required this.oldHexColors,
    required this.onSelectedColors,
  });

  @override
  State<MultiSelectProductColors> createState() =>
      _MultiSelectProductColorsState();
}

class _MultiSelectProductColorsState extends State<MultiSelectProductColors> {
  final List<int> selectedColors = [];

  List<Widget> _buildColorList() {
    List<Widget> choices = [];
    for (final int productColor in widget.hexColors) {
      choices.add(
        ChoiceChip(
          label: circularColor(productColor),
          checkmarkColor: Consts.primaryColor,
          selected: selectedColors.contains(productColor),
          onSelected: (bool selected) {
            setState(() {
              if (selectedColors.contains(productColor)) {
                selectedColors.remove(productColor);
              } else {
                selectedColors.clear();
                selectedColors.add(productColor);
              }
            });
            if (selectedColors.isEmpty) {
              widget.onSelectedColors(null);
            } else {
              widget.onSelectedColors(selectedColors.first);
            }
          },
        ),
      );
    }
    return choices;
  }

  @override
  void initState() {
    selectedColors.clear();
    selectedColors.addAll(widget.oldHexColors);
    super.initState();
  }

  @override
  void dispose() {
    selectedColors.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        myText("Colors"),
        verticalHeight4,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _buildColorList(),
        ),
      ],
    );
  }
}
