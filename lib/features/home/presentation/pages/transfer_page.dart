import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/friend/data/models/friend_model.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_event.dart'
    as event;
import 'package:Dividex/features/friend/presentation/bloc/friend_state.dart';
import 'package:Dividex/features/home/presentation/widgets/square_user.dart';
import 'package:Dividex/features/recharge/presentation/bloc/recharge_bloc.dart';
import 'package:Dividex/features/recharge/presentation/widgets/balance_widget.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart';
import 'package:Dividex/shared/models/enum.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/utils/num.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/content_card.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_dropdown_widget.dart';
import 'package:Dividex/shared/widgets/custom_form_wrapper.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/push_noti_in_app_widget.dart';
import 'package:Dividex/shared/widgets/show_dialog_widget.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class TransferPage extends StatefulWidget {
  final UserModel? toUser;
  final double? amount;
  final CurrencyEnum? currency;
  final String? groupId;

  const TransferPage({
    super.key,
    this.toUser,
    this.amount,
    this.currency,
    this.groupId,
  });

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<UserModel?> selectedToUser = ValueNotifier(null);
  final originalAmount = TextEditingController();
  final realAmount = TextEditingController();
  final description = TextEditingController();
  final List<CurrencyEnum> _units = CurrencyEnum.values;
  final ValueNotifier<CurrencyEnum> _selectedCurrency = ValueNotifier(
    CurrencyEnum.vnd,
  );
  String? groupId;
  
  final clearFormTrigger = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    context.read<LoadedFriendsBloc>().add(
      event.InitialEvent(HiveService.getUser().id),
    );
    context.read<RechargeBloc>().add(GetWalletEvent());

    // Nếu có truyền sẵn người nhận, số tiền, loại tiền tệ từ ngoài
    if (widget.toUser != null) {
      selectedToUser.value = widget.toUser;
    }
    if (widget.amount != null) {
      originalAmount.text = formatNumber(widget.amount!);
    }
    if (widget.currency != null) {
      _selectedCurrency.value = widget.currency!;
    }
    if (widget.groupId != null) {
      groupId = widget.groupId!;
    }
  }

  @override
  void dispose() {
    originalAmount.dispose();
    realAmount.dispose();
    description.dispose();
    selectedToUser.dispose();
    super.dispose();
  }

  Future<void> _handleTransfer(BuildContext context) async {
    double a = double.parse(originalAmount.text.trim().replaceAll('.', ''));
    String des = description.text;
    UserModel toUser = selectedToUser.value!;
    final intl = AppLocalizations.of(context)!;

    if (_selectedCurrency.value != CurrencyEnum.vnd) {
      showCustomDialog(
        context: context,
        content: const Center(
          child: SpinKitFadingCircle(color: AppThemes.primary3Color),
        ),
      );

      try {
        final response = await Dio().get(
          'https://api.forexrateapi.com/v1/latest',
          queryParameters: {
            'api_key': '45e110f921a24cf252ade6d4cc09c774',
            'base': _selectedCurrency.value.name.toUpperCase(), // ví dụ: USD
            'currencies': 'VND',
          },
        );

        Navigator.of(context).pop(); // Ẩn loading

        if (response.data['success'] == true) {
          double rate = (response.data['rates']['VND'] as num).toDouble();
          double converted = a * rate;

          // 🟣 Hiện popup xác nhận
          final bool? confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(intl.confirmTransfer),
              content: Text(
                '${intl.exchangeRateMessage(_selectedCurrency.value.name.toUpperCase(), formatNumber(double.parse(rate.toStringAsFixed(2))))}\n\n${intl.convertedAmountMessage(formatNumber(double.parse(converted.toStringAsFixed(2))))}\n\n${intl.continueQuestion}',
                // 'Tỉ giá hiện tại: 1 ${_selectedCurrency.value.name.toUpperCase()} = ${rate.toStringAsFixed(2)} VND\n\n'
                // 'Số tiền quy đổi: ${converted.toStringAsFixed(0)} VND\n\n'
                // 'Bạn có muốn tiếp tục không?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(intl.cancel),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(intl.confirm),
                ),
              ],
            ),
          );

          // Nếu người dùng đồng ý -> chuyển sang trang xác nhận
          if (confirm == true) {
            context.pushNamed(
              AppRouteNames.transferConfirm,
              extra: {
                'toUser': toUser,
                'originalAmount': a,
                'realAmount': converted,
                'currency': _selectedCurrency.value,
                'description': des.isNotEmpty ? des : null,
                'groupId': groupId,
              },
            );
          }
        } else {
          showCustomToast(
            'Không lấy được tỉ giá, vui lòng thử lại.',
            type: ToastType.error,
          );
        }
      } catch (e) {
        Navigator.of(context).pop(); // Ẩn loading nếu lỗi
        showCustomToast('Có lỗi khi gọi API: $e', type: ToastType.error);
      }

      return;
    }

    context.pushNamed(
      AppRouteNames.transferConfirm,
      extra: {
        'toUser': toUser,
        'originalAmount': a,
        'realAmount': a,
        'currency': _selectedCurrency.value,
        'description': des.isNotEmpty ? des : null,
        'groupId': groupId,
      },
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _handleTransfer(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return AppShell(
      currentIndex: 0,
      child: SimpleLayout(
        onRefresh: () {
          clearFormTrigger.value = !clearFormTrigger.value; // Trigger form reset
          context.read<LoadedFriendsBloc>().add(
            event.InitialEvent(HiveService.getUser().id),
          );
          context.read<RechargeBloc>().add(GetWalletEvent());

          // Nếu có truyền sẵn người nhận, số tiền, loại tiền tệ từ ngoài
          if (widget.toUser != null) {
            selectedToUser.value = widget.toUser;
          }
          if (widget.amount != null) {
            originalAmount.text = formatNumber(widget.amount!);
          }
          if (widget.currency != null) {
            _selectedCurrency.value = widget.currency!;
          }
          if (widget.groupId != null) {
            groupId = widget.groupId!;
          }
          return Future.value();
        },
        title: intl.transfer,
        child: CustomFormWrapper(
          clearTrigger: clearFormTrigger,
          formKey: _formKey,
          fields: [
            FormFieldConfig(controller: originalAmount, isRequired: true),
            FormFieldConfig(selectedValue: selectedToUser, isRequired: true),
          ],
          builder: (isValid) {
            return Column(
              children: [
                ContentCard(
                  child: BlocBuilder<RechargeBloc, RechargeState>(
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
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      intl.chooseBeneficiary,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: 12,
                        letterSpacing: 0,
                        height: 16 / 12,
                        color: Colors.grey,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        context.pushNamed(
                          AppRouteNames.chooseMember,
                          extra: {
                            'id': HiveService.getUser().id,
                            'type': LoadType.friends,
                            'initialSelected': selectedToUser.value != null
                                ? [selectedToUser.value!]
                                : [],
                            'onChanged': (List<UserModel> users) {
                              setState(() {
                                selectedToUser.value = users.isNotEmpty
                                    ? users.first
                                    : null;
                              });
                            },
                            'isMultiSelect': false,
                          },
                        );
                      },
                      child: Text(
                        intl.findBeneficiary,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 12,
                          letterSpacing: 0,
                          height: 16 / 12,
                          color: AppThemes.primary3Color,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Friend
                BlocBuilder<LoadedFriendsBloc, LoadedFriendsState>(
                  buildWhen: (p, c) =>
                      p.requests != c.requests || p.isLoading != c.isLoading,
                  builder: (context, state) {
                    if (state.isLoading) {
                      return Center(
                        child: ColoredBox(
                          color: Colors.transparent,
                          child: SpinKitFadingCircle(
                            color: AppThemes.primary3Color,
                          ),
                        ),
                      );
                    }

                    if (state.requests.isEmpty) {
                      return SizedBox.shrink();
                    }

                    final friends = state.requests;
                    final hasMore = state.page < state.totalPage;

                    if (widget.toUser != null &&
                        !friends.any((f) => f.friendUid == widget.toUser!.id)) {
                      // Nếu người nhận không có trong danh sách bạn bè, thêm vào đầu danh sách
                      friends.insert(
                        0,
                        FriendModel(
                          friendUid: widget.toUser!.id!,
                          fullName: widget.toUser!.fullName!,
                          avatarUrl: widget.toUser!.avatar,
                        ),
                      );
                    }

                    return Container(
                      height: 120,
                      margin: const EdgeInsets.only(top: 8),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: (friends.length + (hasMore ? 1 : 0)),
                        itemBuilder: (context, index) {
                          if (index == friends.length) {
                            context.read<LoadedFriendsBloc>().add(
                              event.LoadMoreFriendsEvent(
                                HiveService.getUser().id,
                                searchQuery: '',
                              ),
                            );
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: SpinKitFadingCircle(
                                  color: const Color(0xFF08AE02),
                                ),
                              ),
                            );
                          }

                          return SquareUser(
                            key: ValueKey(friends[index].friendUid),
                            user: UserModel(
                              id: friends[index].friendUid,
                              fullName: friends[index].fullName,
                              avatar: friends[index].avatarUrl,
                            ),
                            isSelected:
                                selectedToUser.value?.id ==
                                friends[index].friendUid,
                            onTap: () {
                              setState(() {
                                if (selectedToUser.value?.id ==
                                    friends[index].friendUid) {
                                  selectedToUser.value = null;
                                } else {
                                  selectedToUser.value = UserModel(
                                    id: friends[index].friendUid,
                                    fullName: friends[index].fullName,
                                    avatar: friends[index].avatarUrl,
                                  );
                                }
                              });
                            },
                          );
                        },
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                ContentCard(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 340,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 7, // 70%
                              child: CustomTextInputWidget(
                                size: TextInputSize.large,
                                isReadOnly: false,
                                isRequired: true,
                                label: intl.expenseAmountLabel,
                                hintText: intl.expenseAmountHint,
                                controller: originalAmount,
                                keyboardType: TextInputType.number,
                                validator: (value) => CustomValidator()
                                    .validateAmount(value, intl),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 3, // 30%
                              child: ValueListenableBuilder<CurrencyEnum>(
                                valueListenable: _selectedCurrency,
                                builder: (context, value, _) {
                                  return CustomDropdownWidget<CurrencyEnum>(
                                    label: intl.expenseCurrencyLabel,
                                    value: _selectedCurrency.value,
                                    options: _units,
                                    displayString: (b) => b.code,
                                    buildOption: (b, selected) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 6,
                                          horizontal: 4,
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              b.code,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: selected
                                                        ? AppThemes
                                                              .primary3Color
                                                        : Colors.grey,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Text(
                                                b.description,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: selected
                                                          ? AppThemes
                                                                .primary3Color
                                                          : Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                              ),
                                            ),
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
                                      _selectedCurrency.value = val!;
                                    },
                                    isRequired: true,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      CustomTextInputWidget(
                        size: TextInputSize.large,
                        controller: description,
                        keyboardType: TextInputType.text,
                        isReadOnly: false,
                        label: intl.description,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                ValueListenableBuilder<UserModel?>(
                  valueListenable: selectedToUser,
                  builder: (context, toUser, _) {
                    return CustomButton(
                      text: intl.confirm,
                      onPressed: (isValid && toUser != null) ? _submit : null,
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
