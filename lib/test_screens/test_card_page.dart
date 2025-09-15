import 'package:Dividex/shared/widgets/info_card.dart';
import 'package:flutter/material.dart';

class TestCardScreen extends StatelessWidget {
  const TestCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test InfoCard")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account card
          InfoCard(
            title: "Account 1",
            subtitle: "Branch",
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("1900 8988 1234", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("OCB", style: TextStyle(color: Colors.red)),
              ],
            ),
          ),

          InfoCard(
            title: "Account 2",
            subtitle: "Branch",
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("8988 1234", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("VCB", style: TextStyle(color: Colors.red)),
              ],
            ),
          ),

          // User profile card
          InfoCard(
            leading: const CircleAvatar(
              backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=3"),
              radius: 24,
            ),
            title: "Nguyễn Văn A",
            subtitle: "Active now",
            trailing: const Icon(Icons.chat, color: Colors.blue),
            onTap: () {},
          ),

          // Group card
          InfoCard(
            leading: const Icon(Icons.group, size: 32, color: Colors.green),
            title: "Football Team",
            subtitle: "12 members",
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),

          // Event card
          InfoCard(
            leading: const Icon(Icons.event, size: 32, color: Colors.orange),
            title: "Team Meeting",
            subtitle: "Tomorrow 9:00 AM",
            trailing: const Text("Office", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}
