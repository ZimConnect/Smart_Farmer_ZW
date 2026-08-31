import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../../core/db/app_database.dart';

class AnimalFormScreen extends ConsumerStatefulWidget {
  const AnimalFormScreen({super.key});
  @override
  ConsumerState<AnimalFormScreen> createState() => _AnimalFormScreenState();
}

class _AnimalFormScreenState extends ConsumerState<AnimalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tagController = TextEditingController();
  final _breedController = TextEditingController();
  AnimalType? _selectedType;
  DateTime? _dob;

  final List<AnimalType> allAnimals = AnimalType.values;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Animal 🐄')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<AnimalType>(
              decoration: const InputDecoration(labelText: 'Animal Type'),
              items: allAnimals.map((a) => DropdownMenuItem(
                value: a,
                child: Text(a.name.toUpperCase())
              )).toList(),
              onChanged: (val) => setState(() => _selectedType = val),
              validator: (v) => v == null ? 'Select type' : null,
            ),
            TextFormField(
              controller: _tagController,
              decoration: const InputDecoration(labelText: 'Tag ID / Ear Tag'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: _breedController,
              decoration: const InputDecoration(labelText: 'Breed'),
            ),
            ListTile(
              title: Text(_dob == null ? 'Date of Birth' : 'DOB: ${DateFormat.yMd().format(_dob!)}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                _dob = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2010),
                  lastDate: DateTime.now()
                );
                setState(() {});
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveAnimal,
              child: const Text('Save Animal')
            )
          ],
        ),
      ),
    );
  }

  Future<void> _saveAnimal() async {
    if (!_formKey.currentState!.validate()) return;
    final db = ref.read(databaseProvider);
    await db.into(db.animals).insert(AnimalsCompanion.insert(
      farmId: 1, // TODO: use selected farm
      tagId: _tagController.text,
      type: _selectedType!,
      breed: Value(_breedController.text),
      dob: Value(_dob),
    ));
    if(mounted) Navigator.pop(context);
  }
}

final databaseProvider = Provider((ref) => AppDatabase());
