import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class GroupWidget extends StatefulWidget {
  const GroupWidget({super.key});

  @override
  State<GroupWidget> createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  // Dữ liệu giả định cho nhóm và khoản nợ
  final List<Map<String, dynamic>> _groupList = [
    {
      'name': 'Nhà',
      'debtor': 'Em gái ruột yêu dấu',
      'amount': '24.000',
      'hasDebt': true,
      'isOwed': false,
    },
    {
      'name': 'Nhóm đồ án',
      'debtor': 'Quỳnh',
      'amount': '24.000',
      'hasDebt': false,
      'isOwed': true,
    },
    {
      'name': 'Hội độc thân',
      'debtor': '',
      'amount': '0',
      'hasDebt': false,
      'isOwed': false,
    },
  ];

  final _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<String>.empty();
              }
              // Giả lập tìm kiếm nhóm
              return _groupList
                  .where((group) => group['name']!
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase()))
                  .map<String>((group) => group['name'] as String);
            },
            fieldViewBuilder: (
              BuildContext context,
              TextEditingController textEditingController,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted,
            ) {
              return TextField(
                controller: textEditingController,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: intl.searchTab, // Ví dụ: Nhóm lớp
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              );
            },
            onSelected: (String selection) {
              debugPrint('Bạn đã chọn $selection');
              // Xử lý khi chọn một item
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: _groupList.length,
            itemBuilder: (context, index) {
              final group = _groupList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.blueAccent,
                              child: Icon(Icons.group, color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              group['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Hiển thị các thành viên trong nhóm
                        Row(
                          children: List.generate(
                            5,
                            (idx) => const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                                radius: 20,
                                child: Icon(Icons.person, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        if (group['hasDebt'] || group['isOwed']) ...[
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                group['hasDebt'] ? intl.youOwn : intl.ownYou,
                                style: TextStyle(
                                  color: group['hasDebt'] ? Colors.red : Colors.green,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${group['amount']} đ',
                                style: TextStyle(
                                  color: group['hasDebt'] ? Colors.red : Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Xử lý khi nhấn nút
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: group['hasDebt'] ? Colors.red[700] : Colors.green[700],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Text(
                                group['hasDebt'] ? intl.remind : intl.pay,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}