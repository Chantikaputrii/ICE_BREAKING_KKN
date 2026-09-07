import 'package:flutter/material.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    const names = ['Alya', 'Bima', 'Citra'];
    return Scaffold(
      appBar: AppBar(title: const Text('Peringkat')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: names.length,
        itemBuilder: (_, index) => Card(
          child: ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(names[index]),
            trailing: Text('${100 - (index * 10)} poin'),
          ),
        ),
      ),
    );
  }
}
