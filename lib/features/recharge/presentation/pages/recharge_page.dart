import 'dart:async';

import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/recharge/data/models/recharge_model.dart';
import 'package:Dividex/features/recharge/presentation/bloc/recharge_bloc.dart';
import 'package:Dividex/features/recharge/presentation/widgets/balance_widget.dart';
import 'package:Dividex/shared/models/banks.dart';
import 'package:Dividex/shared/utils/download_qr.dart';
import 'package:Dividex/shared/utils/num.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/content_card.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_dropdown_widget.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/push_noti_in_app_widget.dart';
import 'package:Dividex/shared/widgets/show_dialog_widget.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview;
import 'package:url_launcher/url_launcher.dart';

class RechargePage extends StatefulWidget {
  const RechargePage({super.key});

  @override
  State<RechargePage> createState() => _RechargePageState();
}

class _RechargePageState extends State<RechargePage> {
  final balance = 1000000;
  final TextEditingController amountController = TextEditingController();
  List<int> amountExample = [10000, 20000, 50000, 100000, 200000, 500000];

  @override
  void initState() {
    super.initState();
    context.read<RechargeBloc>().add(GetWalletEvent());
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (amountController.text.isEmpty) {
      showCustomToast(
        AppLocalizations.of(context)!.pleaseEnterAmount,
        type: ToastType.error,
      );
      return;
    }
    double a = double.parse(amountController.text.trim());

    //Gọi api nạp tiền, mà chưa có api
    context.read<RechargeBloc>().add(DepositEvent(a, 'VND'));
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return AppShell(
      currentIndex: 0,
      child: SimpleLayout(
        onRefresh: () {
          context.read<RechargeBloc>().add(GetWalletEvent());
          return Future.value();
        },
        title: intl.rechargeIntoApp,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              ContentCard(
                child: Column(
                  children: [
                    BlocBuilder<RechargeBloc, RechargeState>(
                      builder: (context, state) {
                        if (state is GetWalletSuccessState) {
                          return BalanceRow(
                            balanceLabel: intl.balance,
                            balance: state.walletInfo,
                          );
                        }
                        return Container(
                          color: Colors.transparent,
                          child: SpinKitFadingCircle(
                            color: AppThemes.primary3Color,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 8),
                    Divider(height: 1, color: AppThemes.borderColor),
                    const SizedBox(height: 8),
                    CustomTextInputWidget(
                      size: TextInputSize.large,
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      isReadOnly: false,
                      label: intl.amountLabel,
                      isRequired: true,
                      validator: (value) =>
                          CustomValidator().validateAmount(value, intl),
                    ),

                    Wrap(
                      alignment: WrapAlignment.start,
                      children: [
                        ...amountExample.map((amount) {
                          return Container(
                            margin: const EdgeInsets.all(4),
                            child: CustomButton(
                              size: ButtonSize.medium,
                              text: formatNumber(amount),
                              onPressed: () {
                                setState(() {
                                  if (amountController.text !=
                                      amount.toString()) {
                                    amountController.text = amount.toString();
                                  } else {
                                    amountController.text = '0';
                                  }
                                });
                              },
                              customColor:
                                  amountController.text != amount.toString()
                                  ? const Color.fromARGB(137, 232, 140, 160)
                                  : AppThemes.primary3Color,
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              CustomButton(text: intl.confirm, onPressed: _submit),

              BlocListener<RechargeBloc, RechargeState>(
                listener: (context, state) {
                  if (state is VnPayLinkState) {
                    showCustomDialog(
                      context: context,
                      label: intl.rechargeIntoApp,
                      content: SizedBox(
                        height: MediaQuery.of(context).size.height * 1.5,
                        child: _buildVnPayWebView(state.link),
                      ),
                    );
                  } else if (state is PayOsCheckOutLinkState) {
                    showTransferPopup(context, state.link);
                  }
                },
                child: Container(), // BlocBuilder không cần thiết
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVnPayWebView(String link) {
    final controller = webview.WebViewController()
      ..setJavaScriptMode(webview.JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: (message) {
          debugPrint('Message from web: ${message.message}');
          context.read<RechargeBloc>().add(
            CreateDepositEvent(
              double.parse(amountController.text.trim()),
              'VND',
              'NCB',
            ),
          );
          context.read<RechargeBloc>().add(
            GetWalletEvent(),
          ); // Cập nhật lại số dư ví
          Navigator.pop(context);
        },
      )
      ..setNavigationDelegate(
        webview.NavigationDelegate(
          onWebResourceError: (error) {
            debugPrint('Web error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(link));

    return SafeArea(child: webview.WebViewWidget(controller: controller));
  }

  void showTransferPopup(BuildContext context, PayOSResponseModel link) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return TransferPopup(
          orderCode: link.orderCode,
          qrData: link.qrCode,
          bottomSheetContext: bottomSheetContext,
        );
      },
    ).then((value) {
      context.read<RechargeBloc>().add(GetWalletEvent());

      if (value != 'success') {
        context.read<RechargeBloc>().add(CancelDepositEvent(link.orderCode));
      }
    });
  }
}

class TransferPopup extends StatefulWidget {
  final String qrData;
  final int orderCode;
  final BuildContext bottomSheetContext;

  const TransferPopup({
    super.key,
    required this.orderCode,
    required this.qrData,
    required this.bottomSheetContext,
  });

  @override
  State<TransferPopup> createState() => _TransferPopupState();
}

class _TransferPopupState extends State<TransferPopup> {
  bool _closed = false;
  ValueNotifier<BankInfo?> selectedBranch = ValueNotifier(null);
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _startPolling();
  }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 7), (_) {
      if (_closed) return;

      context.read<RechargeBloc>().add(
        CheckRechargeStatusEvent(widget.orderCode.toString()),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); 
    selectedBranch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: BlocListener<RechargeBloc, RechargeState>(
        listener: (context, state) {
          if (state is DepositSuccessState && !_closed) {
            _closed = true;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Navigator.of(
                widget.bottomSheetContext,
                rootNavigator: true,
              ).canPop()) {
                Navigator.of(
                  widget.bottomSheetContext,
                  rootNavigator: true,
                ).pop('success');
              }
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      intl.topUpTitle,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(
                        widget.bottomSheetContext,
                        rootNavigator: true,
                      ).pop('cancel'),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
            
                const SizedBox(height: 16),
            
                // Card QR
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      // QR từ link
                      RepaintBoundary(
                        key: qrKey,
                        child: QrImageView(
                          data: widget.qrData,
                          size: 250,
                          backgroundColor: Colors.white, // rất quan trọng
                        ),
                      ),
            
                      const SizedBox(height: 12),
            
                      Text(
                        '${intl.scanQrDesc} ${intl.noManualTransfer}',
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall!.copyWith(color: Colors.grey),
                      ),
            
                      const SizedBox(height: 12),
            
                      CustomButton(
                        text: intl.downloadQr,
                        onPressed: () async {
                          final success = await saveQrImage();
                          if (success) {
                            showCustomToast(
                              intl.savedToGallery,
                              type: ToastType.success,
                            );
                          } else {
                            showCustomToast(
                              intl.failedToSaveQr,
                              type: ToastType.error,
                            );
                          }
                        },
                      ),
            
                      const SizedBox(height: 12),
            
                      ValueListenableBuilder<BankInfo?>(
                        valueListenable: selectedBranch,
                        builder: (context, value, _) {
                          return CustomDropdownWidget<BankInfo>(
                            label: intl.bank,
                            value: value,
                            options: banksCanOpen,
                            displayString: (b) => b.shortName,
                            buildOption: (b, selected) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 4,
                                ),
                                child: Row(
                                  children: [
                                    Image.network(
                                      b.logo,
                                      height: 50,
                                      width: 100,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.account_balance),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      b.code,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: selected
                                                ? AppThemes.primary3Color
                                                : Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    const SizedBox(width: 16),
                                    if (selected)
                                      const Icon(
                                        Icons.check,
                                        color: AppThemes.primary3Color,
                                      ),
                                  ],
                                ),
                              );
                            },
                            onChanged: (val) {
                              selectedBranch.value = val;
                            },
                            isRequired: true,
                          );
                        },
                      ),
            
                      const SizedBox(height: 12),
            
                      CustomButton(
                        text: intl.openInBankApp,
                        onPressed: () async {
                          final uri = Uri.parse(
                            'https://dl.vietqr.io/pay?app=${selectedBranch.value?.code.toLowerCase() ?? ''}',
                          );
            
                          try {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          } catch (e) {
                            showCustomToast(
                              intl.cannotOpenBankApp,
                              type: ToastType.error,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
            
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
