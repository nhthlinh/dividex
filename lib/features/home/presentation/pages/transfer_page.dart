import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/routes/router.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:Dividex/features/friend/presentation/bloc/friend_event.dart'
    as event;
import 'package:Dividex/features/friend/presentation/bloc/friend_state.dart';
import 'package:Dividex/features/user/data/models/user_model.dart';
import 'package:Dividex/features/user/presentation/bloc/user_event.dart';
import 'package:Dividex/shared/services/local/hive_service.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/app_shell.dart';
import 'package:Dividex/shared/widgets/content_card.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_form_wrapper.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<UserModel?> selectedToUser = ValueNotifier(null);
  final amount = TextEditingController();
  final description = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<LoadedFriendsBloc>().add(
      event.InitialEvent(HiveService.getUser().id),
    );
  }

  @override
  void dispose() {
    amount.dispose();
    description.dispose();
    selectedToUser.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      double a = double.parse(amount.text.trim());
      String des = description.text.trim();
      UserModel toUser = selectedToUser.value!;

      context.pushNamed(
        AppRouteNames.transferConfirm,
        extra: {
          'toUser': toUser,
          'amount': a,
          'description': des.isNotEmpty ? des : null,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return AppShell(
      currentIndex: 0,
      child: SimpleLayout(
        title: intl.transfer,
        child: CustomFormWrapper(
          formKey: _formKey,
          fields: [
            FormFieldConfig(controller: amount, isRequired: true),
            FormFieldConfig(selectedValue: selectedToUser, isRequired: true),
          ],
          builder: (isValid) {
            return Column(
              children: [
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
                const SizedBox(height: 8),
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

                    return ListView.builder(
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

                        if (selectedToUser.value != null) {
                          // if (friends[index].friendUid ==
                          //     selectedToUser.value?.id) {
                          //   return SquareIconUser(
                          //     key: ValueKey(friends[index].friendUid),
                          //     user: UserModel(
                          //       id: friends[index].friendUid,
                          //       fullName: friends[index].fullName,
                          //       avatar: friends[index].avatarUrl,
                          //     ),
                          //     size: 100,
                          //     onTap: () {
                          //       selectedToUser.value = null;
                          //     },
                          //     isSelectable: true,
                          //     backgroundColor: AppThemes.primary4Color,
                          //   );
                          // }
                        }

                        return SizedBox.shrink();

                    //     return SquareIconUser(
                    //       key: ValueKey(friends[index].friendUid),
                    //       user: UserModel(
                    //         id: friends[index].friendUid,
                    //         fullName: friends[index].fullName,
                    //         avatar: friends[index].avatarUrl,
                    //       ),
                    //       size: 100,
                    //       onTap: () {
                    //         selectedToUser.value = UserModel(
                    //           id: friends[index].friendUid,
                    //           fullName: friends[index].fullName,
                    //           avatar: friends[index].avatarUrl,
                    //         );
                    //       },
                    //       isSelectable: true,
                    //     );
                      },
                    );
                  },
                ),

                const SizedBox(height: 16),

                ContentCard(
                  child: Column(
                    children: [
                      CustomTextInputWidget(
                        size: TextInputSize.large,
                        controller: amount,
                        keyboardType: TextInputType.number,
                        isReadOnly: false,
                        label: intl.amount,
                        isRequired: true,
                        validator: (value) =>
                            CustomValidator().validateAmount(value, intl),
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

                CustomButton(
                  text: intl.confirm,
                  onPressed: isValid ? _submit : () {},
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
