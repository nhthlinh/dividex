import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class FriendWidget extends StatefulWidget {
  const FriendWidget({super.key});

  @override
  State<FriendWidget> createState() => _FriendWidgetState();
}

class _FriendWidgetState extends State<FriendWidget> {
  // Dữ liệu giả định cho bạn bè và khoản nợ
  final List<Map<String, dynamic>> _friendList = [
    {
      'name': 'Nguyễn Hà Thùy Linh',
      'amount': '250.000',
      'hasDebt': true,
      'isOwed': false,
    },
    {
      'name': 'Nguyễn Hà Thùy Linh',
      'amount': '250.000',
      'hasDebt': false,
      'isOwed': true,
    },
    {
      'name': 'Nguyễn Hà Thùy Linh',
      'amount': '250.000',
      'hasDebt': false,
      'isOwed': true,
    },
  ];

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
              // Giả lập tìm kiếm bạn bè
              return _friendList
                  .where((friend) => friend['name']!
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase()))
                  .map<String>((friend) => friend['name'] as String);
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
                  hintText: intl.searchTab, // Ví dụ: Thùy Linh
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
            itemCount: _friendList.length,
            itemBuilder: (context, index) {
              final friend = _friendList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                          radius: 25,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                friend['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    friend['hasDebt'] ? Icons.arrow_forward_sharp : Icons.arrow_back_sharp,
                                    color: friend['hasDebt'] ? Colors.red : Colors.green,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    friend['hasDebt'] ? intl.youOwn : intl.ownYou,
                                    style: TextStyle(
                                      color: friend['hasDebt'] ? Colors.red : Colors.green,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${friend['amount']} đ',
                                    style: TextStyle(
                                      color: friend['hasDebt'] ? Colors.red : Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Nút hành động
                        SizedBox(
                          width: 80,
                          child: ElevatedButton(
                            onPressed: () {
                              // Xử lý khi nhấn nút
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: friend['hasDebt'] ? Colors.green[700] : Colors.red[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Text(
                              friend['hasDebt'] ? intl.pay : intl.remind,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
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