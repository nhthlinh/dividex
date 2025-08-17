import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class Member {
  final String id;
  final String name;
  final String avatarUrl;

  Member({required this.id, required this.name, required this.avatarUrl});
}

class MemberSelector extends StatefulWidget {
  final List<Member> initialSelectedMembers;
  final ValueChanged<List<Member>> onSelectedMembersChanged;

  const MemberSelector({
    super.key,
    required this.onSelectedMembersChanged,
    required this.initialSelectedMembers,
  });

  @override
  State<MemberSelector> createState() => _MemberSelectorState();
}

class _MemberSelectorState extends State<MemberSelector> {
  final List<Member> _selectedMembers = [];
  List<Member> members = [];

  void _toggleMember(Member member) {
    setState(() {
      if (_selectedMembers.contains(member)) {
        _selectedMembers.remove(member);
      } else {
        _selectedMembers.add(member);
      }
      widget.onSelectedMembersChanged(_selectedMembers);
    });
  }

  @override
  void initState() {
    super.initState();
    // Load initial selected members if needed

    members = [
      Member(
        id: '1',
        name: 'John Doe',
        avatarUrl: 'https://example.com/john.jpg',
      ),
      Member(
        id: '2',
        name: 'Jane Smith',
        avatarUrl: 'https://example.com/jane.jpg',
      ),
      Member(
        id: '3',
        name: 'Alice Johnson',
        avatarUrl: 'https://example.com/alice.jpg',
      ),
      Member(
        id: '4',
        name: 'Bob Brown',
        avatarUrl: 'https://example.com/bob.jpg',
      ),
      Member(
        id: '5',
        name: 'Charlie Davis',
        avatarUrl: 'https://example.com/charlie.jpg',
      ),
      Member(
        id: '6',
        name: 'David Wilson',
        avatarUrl: 'https://example.com/david.jpg',
      ),
    ];

    _selectedMembers.addAll(widget.initialSelectedMembers);
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          intl.eventMembers,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).primaryColor, // Màu chữ của label
          ),
        ),
        const SizedBox(height: 8),
        // Hiển thị các member đã chọn
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _selectedMembers.map((m) {
            return GestureDetector(
              onTap: () => _toggleMember(m),
              child: Chip(
                avatar: CircleAvatar(
                  backgroundImage: NetworkImage(m.avatarUrl),
                ),
                label: Text(m.name),
                deleteIcon: const Icon(Icons.close),
                onDeleted: () => _toggleMember(m),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        // Hiển thị list member để chọn
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: members.length,
          itemBuilder: (context, index) {
            final member = members[index];
            final isSelected = _selectedMembers.contains(member);

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(member.avatarUrl),
              ),
              title: Text(member.name),
              trailing: isSelected
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : const Icon(Icons.circle_outlined),
              onTap: () => _toggleMember(member),
            );
          },
        ),
      ],
    );
  }
}
