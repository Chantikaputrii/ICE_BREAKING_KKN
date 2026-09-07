import 'package:flutter/material.dart';

class LearningMaterialPage extends StatelessWidget {
  const LearningMaterialPage({super.key});

  @override
  Widget build(BuildContext context) {
    const subjects = ['Matematika', 'Bahasa Indonesia', 'PKN', 'IPA', 'Logika'];
    return Scaffold(
      appBar: AppBar(title: const Text('Materi')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: subjects.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (_, index) => Card(
          child: ListTile(
            leading: const Icon(Icons.menu_book_outlined),
            title: Text(subjects[index]),
            subtitle: const Text('Pilih untuk mulai belajar'),
          ),
        ),
      ),
    );
  }
}
