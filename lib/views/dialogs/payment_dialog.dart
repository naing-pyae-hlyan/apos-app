import 'package:apos_app/lib_exp.dart';

void showPaymentDialog(
  BuildContext context, {
  required Function(String) onSelectedBank,
}) =>
    showAdaptiveDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _PaymentDialog(
        onSelectedBank: onSelectedBank,
      ),
    );

class _PaymentDialog extends StatelessWidget {
  final Function(String) onSelectedBank;
  const _PaymentDialog({
    required this.onSelectedBank,
  });

  @override
  Widget build(BuildContext context) {
    final width = context.screenWidth * 0.3;
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Consts.secondaryColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      title: myTitle(
        "Please select payment",
        textAlign: TextAlign.center,
      ),
      content: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: Consts.bankLogoList.map(
          (MMBank bank) {
            return Clickable(
              onTap: () {
                onSelectedBank(bank.name);
                context.pop();
              },
              child: MyCard(
                padding: const EdgeInsets.all(4),
                child: Image.asset(
                  bank.logo,
                  width: width,
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
