import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/shared/widgets/custom_dropdown_widget.dart';
import 'package:flutter/material.dart';

class Bank {
  final String code;
  final String name;
  final String? logo;

  Bank({required this.code, required this.name, this.logo});
}

class TestDropdownPage extends StatefulWidget {
  const TestDropdownPage({super.key});

  @override
  State<TestDropdownPage> createState() => _TestDropdownPageState();
}

class _TestDropdownPageState extends State<TestDropdownPage> {
  Bank? selectedBank;

  final banks = [
    Bank(
      code: "VCB",
      name: "Vietcombank",
      logo: "https://api.vietqr.io/img/ABB.png",
    ),
    Bank(
      code: "ACB",
      name: "Asia Commercial Bank",
      logo: "https://api.vietqr.io/img/ACB.png",
    ),
    Bank(
      code: "TCB",
      name: "Techcombank",
      logo: "https://api.vietqr.io/img/TCB.png",
    ),
    Bank(
      code: "VCB",
      name: "Vietcombank",
      logo: "https://api.vietqr.io/img/ABB.png",
    ),
    Bank(
      code: "ACB",
      name: "Asia Commercial Bank",
      logo: "https://api.vietqr.io/img/ACB.png",
    ),
    Bank(
      code: "TCB",
      name: "Techcombank",
      logo: "https://api.vietqr.io/img/TCB.png",
    ),
    Bank(
      code: "VCB",
      name: "Vietcombank",
      logo: "https://api.vietqr.io/img/ABB.png",
    ),
    Bank(
      code: "ACB",
      name: "Asia Commercial Bank",
      logo: "https://api.vietqr.io/img/ACB.png",
    ),
    Bank(
      code: "TCB",
      name: "Techcombank",
      logo: "https://api.vietqr.io/img/TCB.png",
    ),
    Bank(
      code: "VCB",
      name: "Vietcombank",
      logo: "https://api.vietqr.io/img/ABB.png",
    ),
    Bank(
      code: "ACB",
      name: "Asia Commercial Bank",
      logo: "https://api.vietqr.io/img/ACB.png",
    ),
    Bank(
      code: "TCB",
      name: "Techcombank",
      logo: "https://api.vietqr.io/img/TCB.png",
    ),
    Bank(
      code: "VCB",
      name: "Vietcombank",
      logo: "https://api.vietqr.io/img/ABB.png",
    ),
    Bank(
      code: "ACB",
      name: "Asia Commercial Bank",
      logo: "https://api.vietqr.io/img/ACB.png",
    ),
    Bank(
      code: "TCB",
      name: "Techcombank",
      logo: "https://api.vietqr.io/img/TCB.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomDropdownWidget<Bank>(
          label: "Branch",
          value: selectedBank,
          options: banks,
          displayString: (b) =>
              "${b.code} - ${b.name}", // chỉ hiển thị text khi chọn
          buildOption: (b, selected) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Row(
                children: [
                  if (b.logo != null)
                    Image.network(
                      b.logo!,
                      width: 50,
                      height: 50,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.account_balance),
                    )
                  else
                    const Icon(Icons.account_balance),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "${b.code} ${b.name}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: selected ? AppThemes.primary3Color : Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (selected)
                    const Icon(Icons.check, color: AppThemes.primary3Color),
                ],
              ),
            );
          },
          onChanged: (val) {
            setState(() => selectedBank = val);
          },
          isRequired: true,
        ),
      
      ),
    );
  }
}
