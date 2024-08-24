import 'dart:convert';

import 'package:apos_app/lib_exp.dart';

class StepPaymentInfo extends StatefulWidget {
  final ValueNotifier<MMBank?> bankNotifier;
  final ValueNotifier<String?> base64PaymentSsNotifier;
  final Function() onTapBack;
  final Function() onTapNext;
  const StepPaymentInfo({
    super.key,
    required this.bankNotifier,
    required this.base64PaymentSsNotifier,
    required this.onTapBack,
    required this.onTapNext,
  });

  @override
  State<StepPaymentInfo> createState() => _StepPaymentInfoState();
}

class _StepPaymentInfoState extends State<StepPaymentInfo> {
  final bankErrorNotifier = ValueNotifier<String?>(null);
  final paymentSsErrorNotifier = ValueNotifier<String?>(null);
  double width = 96;

  void onTapNext() {
    bankErrorNotifier.value = null;
    paymentSsErrorNotifier.value = null;

    if (widget.bankNotifier.value == null) {
      bankErrorNotifier.value = "Please select your bank.";
      return;
    }
    if (widget.base64PaymentSsNotifier.value == null) {
      paymentSsErrorNotifier.value = "Please upload your payment screenshot.";
      return;
    }

    widget.onTapNext();
  }

  @override
  Widget build(BuildContext context) {
    width = context.screenWidth * 0.24;
    return MyStep(
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: MyButton(
              label: "Order Info",
              icon: Icons.arrow_back,
              backgroundColor: Consts.secondaryColor,
              labelColor: Consts.primaryColor,
              onPressed: widget.onTapBack,
            ),
          ),
          horizontalWidth12,
          Expanded(
            child: MyButton(
              label: "Confirm",
              icon: Icons.arrow_forward_sharp,
              onPressed: onTapNext,
            ),
          ),
        ],
      ),
      children: [
        myTitle("Select payment"),
        verticalHeight8,
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 8,
          runSpacing: 8,
          children: Consts.bankLogoList.map((MMBank bank) {
            return Clickable(
              onTap: () {
                widget.bankNotifier.value = bank;
                bankErrorNotifier.value = null;
              },
              child: ValueListenableBuilder(
                  valueListenable: widget.bankNotifier,
                  builder: (_, mmBank, __) {
                    if (mmBank == bank) {
                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          _bankCard(bank),
                          checked(),
                        ],
                      );
                    }
                    return _bankCard(bank);
                  }),
            );
          }).toList(),
        ),
        ValueListenableBuilder(
          valueListenable: bankErrorNotifier,
          builder: (_, String? error, __) {
            if (error == null) return emptyUI;
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: errorText(error),
            );
          },
        ),
        verticalHeight16,
        myTitle("Add your payment receipt"),
        verticalHeight8,
        ValueListenableBuilder(
          valueListenable: widget.base64PaymentSsNotifier,
          builder: (_, String? base64Image, __) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Consts.primaryColor),
                borderRadius: BorderRadius.circular(8),
              ),
              width: context.screenWidth,
              padding: const EdgeInsets.all(24),
              child:
                  base64Image == null ? addImageCard : imageCard(base64Image),
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: paymentSsErrorNotifier,
          builder: (_, String? error, __) {
            if (error == null) return emptyUI;
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: errorText(error),
            );
          },
        ),
        verticalHeight24,
      ],
    );
  }

  Widget get addImageCard => Clickable(
        onTap: () async {
          final file = await ImagePickerUtils.pickImage();
          if (file != null) {
            widget.base64PaymentSsNotifier.value = base64Encode(
              file.data,
            );
            paymentSsErrorNotifier.value = null;
          }
        },
        radius: 12,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.upload_file,
              color: Consts.primaryColor,
            ),
            verticalHeight8,
            myText("Upload Receipt"),
          ],
        ),
      );

  Widget imageCard(String image) => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              child: Image.memory(
                base64Decode(image),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.add_a_photo_outlined),
              ),
            ),
            Positioned(
              top: -8,
              right: -8,
              child: IconButton(
                onPressed: () {
                  widget.base64PaymentSsNotifier.value = null;
                },
                icon: const Icon(
                  Icons.remove_circle,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _bankCard(MMBank bank) => MyCard(
        padding: const EdgeInsets.all(4),
        child: Image.asset(
          bank.logo,
          width: width,
          fit: BoxFit.contain,
        ),
      );
}
