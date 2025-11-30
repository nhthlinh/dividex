import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/config/themes/app_theme.dart';
import 'package:Dividex/features/event_expense/data/models/category_model.dart';
import 'package:Dividex/features/event_expense/data/models/event_model.dart';
import 'package:Dividex/features/event_expense/presentation/widgets/date_input_field_widget.dart';
import 'package:Dividex/features/group/data/models/group_model.dart';
import 'package:Dividex/features/group/presentation/bloc/group_bloc.dart';
import 'package:Dividex/features/group/presentation/bloc/group_event.dart';
import 'package:Dividex/features/group/presentation/bloc/group_state.dart';
import 'package:Dividex/features/search/data/model/filter_model.dart';
import 'package:Dividex/shared/utils/validation_input.dart';
import 'package:Dividex/shared/widgets/custom_button.dart';
import 'package:Dividex/shared/widgets/custom_dropdown_widget.dart';
import 'package:Dividex/shared/widgets/custom_text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class ExpenseFilterWidget extends StatefulWidget {
  final ExpenseFilterArguments? filter;
  final void Function(ExpenseFilterArguments)? onApply;

  const ExpenseFilterWidget({super.key, this.filter, this.onApply});

  @override
  State<ExpenseFilterWidget> createState() => _ExpenseFilterWidgetState();
}

class _ExpenseFilterWidgetState extends State<ExpenseFilterWidget> {
  DateTime? startDate;
  DateTime? endDate;
  double? minAmount;
  double? maxAmount;

  String? name;
  String? eventId;
  String? groupId;
  String? category;

  final amountControllerFrom = TextEditingController();
  final amountControllerTo = TextEditingController();
  final startController = TextEditingController();
  final endController = TextEditingController();
  final ValueNotifier<CategoryModel?> selectedCategory = ValueNotifier(null);
  final ValueNotifier<GroupModel?> selectedGroup = ValueNotifier(null);
  final ValueNotifier<EventModel?> selectedEvent = ValueNotifier(null);

  @override
  void dispose() {
    amountControllerFrom.dispose();
    amountControllerTo.dispose();
    startController.dispose();
    endController.dispose();
    selectedCategory.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<LoadedGroupsBloc>().add(InitialEvent('', false));

    if (widget.filter != null) {
      amountControllerFrom.text = widget.filter?.minAmount?.toString() ?? '';
      amountControllerTo.text = widget.filter?.maxAmount?.toString() ?? '';
      startController.text = widget.filter?.start != null
          ? DateFormat('dd/MM/yyyy').format(widget.filter!.start!)
          : '';
      endController.text = widget.filter?.end != null
          ? DateFormat('dd/MM/yyyy').format(widget.filter!.end!)
          : '';
      eventId = widget.filter?.eventId;
      groupId = widget.filter?.groupId;
      category = widget.filter?.category;
      if (widget.filter?.category != null) {
        selectedCategory.value = CategoryModel.categories.firstWhere(
          (c) => c.key == widget.filter!.category,
        );
      } 
      name = widget.filter?.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 8),
        // Date Range Inputs
        SizedBox(
          width: 340,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5, // 60%
                child: DateInputField(
                  label: intl.from,
                  hintText: '13/05/2025',
                  controller: startController,
                  size: TextInputSize.large,
                  validator: null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 5, // 40%
                child: DateInputField(
                  label: intl.to,
                  hintText: '13/05/2025',
                  controller: endController,
                  size: TextInputSize.large,
                  validator: null,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        // Amount Range Inputs
        SizedBox(
          width: 340,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: CustomTextInputWidget(
                  size: TextInputSize.large,
                  isReadOnly: false,
                  label: intl.from,
                  hintText: intl.expenseAmountHint,
                  controller: amountControllerFrom,
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      CustomValidator().validateAmount(value, intl),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 5,
                child: CustomTextInputWidget(
                  size: TextInputSize.large,
                  isReadOnly: false,
                  label: intl.to,
                  hintText: intl.expenseAmountHint,
                  controller: amountControllerTo,
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      CustomValidator().validateAmount(value, intl),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        //Category
        ValueListenableBuilder<CategoryModel?>(
          valueListenable: selectedCategory,
          builder: (context, value, _) {
            return CustomDropdownWidget<CategoryModel>(
              label: intl.expenseCategoryLabel,
              value: selectedCategory.value,
              options: CategoryModel.categories,
              displayString: (b) => b.localizedName(context),
              buildOption: (b, selected) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 4,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          b.localizedName(context),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: selected
                                    ? AppThemes.primary3Color
                                    : Colors.grey,
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
                selectedCategory.value = val;
              },
            );
          },
        ),
        SizedBox(height: 16),
        //Group
        BlocBuilder<LoadedGroupsBloc, LoadedGroupsState>(
          buildWhen: (p, c) =>
              p.groups != c.groups || p.isLoading != c.isLoading,
          builder: (context, state) {
            if (state.isLoading) {
              return Center(
                child: ColoredBox(
                  color: Colors.transparent,
                  child: SpinKitFadingCircle(color: AppThemes.primary3Color),
                ),
              );
            }

            if (state.groups.isEmpty) {
              return SizedBox.shrink();
            }
            if (widget.filter?.groupId != null) {
              selectedGroup.value = context.read<LoadedGroupsBloc>().state.groups.firstWhere(
                (g) => g.name == widget.filter!.groupId,
              );
            }
            return ValueListenableBuilder<GroupModel?>(
              valueListenable: selectedGroup,
              builder: (context, value, _) {
                return CustomDropdownWidget<GroupModel>(
                  label: intl.eventGroupLabel,
                  value: selectedGroup.value,
                  options: state.groups,
                  displayString: (b) => "${b.name}",
                  buildOption: (b, selected) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 4,
                      ),
                      child: Row(
                        children: [
                          if (b.avatarUrl != null)
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                b.avatarUrl!.publicUrl,
                              ),
                              backgroundColor: Colors.transparent,
                            )
                          else
                            SizedBox(width: 40, child: const Icon(Icons.group)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "${b.name}",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: selected
                                        ? AppThemes.primary3Color
                                        : Colors.grey,
                                    fontWeight: FontWeight.w500,
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
                    setState(() => selectedGroup.value = val);
                    context.read<LoadedGroupsEventsBloc>().add(
                      LoadGroupEventsEventInitial(
                        page: 1,
                        pageSize: 10,
                        groupId: selectedGroup.value?.id ?? '',
                        searchQuery: '',
                      ),
                    );
                  },
                  isRequired: true,
                );
              },
            );
          },
        ),
        
        SizedBox(height: 16),
        // Event
        if (selectedGroup.value != null) ... [
          BlocBuilder<LoadedGroupsEventsBloc, LoadedGroupsEventsState>(
            buildWhen: (p, c) =>
                p.events != c.events || p.isLoading != c.isLoading,
            builder: (context, state) {
              if (state.isLoading) {
                return Center(
                  child: ColoredBox(
                    color: Colors.transparent,
                    child: SpinKitFadingCircle(color: AppThemes.primary3Color),
                  ),
                );
              }

              if (state.events.isEmpty) {
                return SizedBox.shrink();
              }
              if (widget.filter?.eventId != null) {
                selectedEvent.value = context.read<LoadedGroupsEventsBloc>().state.events.firstWhere(
                  (g) => g.name == widget.filter!.eventId,
                );
              }
              return ValueListenableBuilder<EventModel?>(
                valueListenable: selectedEvent,
                builder: (context, value, _) {
                  return CustomDropdownWidget<EventModel>(
                    label: intl.expenseEventLabel,
                    value: selectedEvent.value,
                    options: state.events,
                    displayString: (b) => "${b.name}",
                    buildOption: (b, selected) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 4,
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 40, child: const Icon(Icons.event)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "${b.name}",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: selected
                                          ? AppThemes.primary3Color
                                          : Colors.grey,
                                      fontWeight: FontWeight.w500,
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
                      setState(() => selectedEvent.value = val);
                    },
                    isRequired: true,
                  );
                },
              );
            },
          ),
          
        ],
        SizedBox(height: 16),

        CustomButton(
          size: ButtonSize.large,
          onPressed: () {
            final filter = ExpenseFilterArguments(
              start: startController.text.isNotEmpty
                  ? DateFormat("dd/MM/yyyy").parse(startController.text)
                  : null,
              end: endController.text.isNotEmpty
                  ? DateFormat("dd/MM/yyyy").parse(endController.text)
                  : null,
              minAmount: double.tryParse(amountControllerFrom.text),
              maxAmount: double.tryParse(amountControllerTo.text),
              name: name, 
              groupId: selectedGroup.value?.name,
              eventId: selectedEvent.value?.name,
              category: selectedCategory.value?.key,
            );
            if (widget.onApply != null) {
              widget.onApply!(filter);
            }
          },
          text: intl.accept,
        ),
      ],
    );
  }
}
