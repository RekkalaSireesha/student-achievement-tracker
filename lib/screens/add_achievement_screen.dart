import 'package:flutter/material.dart';
import '../models/achievement.dart';

class AddAchievementScreen extends StatefulWidget {
  final Achievement? achievement;

  const AddAchievementScreen({
    super.key,
    this.achievement,
  });

  @override
  State<AddAchievementScreen> createState() =>
      _AddAchievementScreenState();
}

class _AddAchievementScreenState
    extends State<AddAchievementScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController =
      TextEditingController();

  final TextEditingController descriptionController =
      TextEditingController();

  String selectedCategory = 'Academic';
  String selectedLevel = 'College';

  DateTime? selectedDate;

  bool get isEditing => widget.achievement != null;

  @override
  void initState() {
    super.initState();

    // If editing, load existing data
    if (widget.achievement != null) {
      titleController.text =
          widget.achievement!.title;

      descriptionController.text =
          widget.achievement!.description;

      selectedCategory =
          widget.achievement!.category;

      selectedLevel =
          widget.achievement!.level;

      selectedDate =
          widget.achievement!.date;
    }
  }

  Future<void> pickDate() async {
    final DateTime? pickedDate =
        await showDatePicker(
      context: context,
      initialDate:
          selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void saveAchievement() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select an achievement date',
          ),
        ),
      );

      return;
    }

    final achievement = Achievement(
      title: titleController.text.trim(),
      category: selectedCategory,
      level: selectedLevel,
      date: selectedDate!,
      description:
          descriptionController.text.trim(),
    );

    Navigator.pop(
      context,
      achievement,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing
              ? 'Edit Achievement'
              : 'Add Achievement',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              // --------------------------------
              // TITLE
              // --------------------------------

              const Text(
                'Achievement Title',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: titleController,

                decoration:
                    const InputDecoration(
                  hintText:
                      'Enter achievement title',
                  border:
                      OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.emoji_events,
                  ),
                ),

                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter achievement title';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // --------------------------------
              // CATEGORY
              // --------------------------------

              const Text(
                'Category',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                initialValue: selectedCategory,

                decoration:
                    const InputDecoration(
                  border:
                      OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.category,
                  ),
                ),

                items: const [
                  DropdownMenuItem(
                    value: 'Academic',
                    child:
                        Text('Academic'),
                  ),
                  DropdownMenuItem(
                    value: 'Coding',
                    child:
                        Text('Coding'),
                  ),
                  DropdownMenuItem(
                    value: 'Certification',
                    child:
                        Text('Certification'),
                  ),
                  DropdownMenuItem(
                    value: 'Sports',
                    child:
                        Text('Sports'),
                  ),
                  DropdownMenuItem(
                    value: 'Hackathon',
                    child:
                        Text('Hackathon'),
                  ),
                  DropdownMenuItem(
                    value: 'Cultural',
                    child:
                        Text('Cultural'),
                  ),
                ],

                onChanged: (value) {
                  setState(() {
                    selectedCategory =
                        value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              // --------------------------------
              // LEVEL
              // --------------------------------

              const Text(
                'Achievement Level',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                initialValue: selectedLevel,

                decoration:
                    const InputDecoration(
                  border:
                      OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.military_tech,
                  ),
                ),

                items: const [
                  DropdownMenuItem(
                    value: 'College',
                    child:
                        Text('College'),
                  ),
                  DropdownMenuItem(
                    value: 'State',
                    child:
                        Text('State'),
                  ),
                  DropdownMenuItem(
                    value: 'National',
                    child:
                        Text('National'),
                  ),
                  DropdownMenuItem(
                    value: 'International',
                    child:
                        Text('International'),
                  ),
                ],

                onChanged: (value) {
                  setState(() {
                    selectedLevel =
                        value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              // --------------------------------
              // DATE
              // --------------------------------

              const Text(
                'Achievement Date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              InkWell(
                onTap: pickDate,

                child: InputDecorator(
                  decoration:
                      const InputDecoration(
                    border:
                        OutlineInputBorder(),
                    prefixIcon: Icon(
                      Icons.calendar_month,
                    ),
                  ),

                  child: Text(
                    selectedDate == null
                        ? 'Select date'
                        : '${selectedDate!.day}/'
                          '${selectedDate!.month}/'
                          '${selectedDate!.year}',
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // --------------------------------
              // DESCRIPTION
              // --------------------------------

              const Text(
                'Description',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller:
                    descriptionController,

                maxLines: 4,

                decoration:
                    const InputDecoration(
                  hintText:
                      'Describe your achievement',
                  border:
                      OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.description,
                  ),
                ),

                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter a description';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              // --------------------------------
              // SAVE / UPDATE BUTTON
              // --------------------------------

              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton.icon(
                  onPressed:
                      saveAchievement,

                  icon: Icon(
                    isEditing
                        ? Icons.edit
                        : Icons.save,
                  ),

                  label: Text(
                    isEditing
                        ? 'UPDATE ACHIEVEMENT'
                        : 'SAVE ACHIEVEMENT',

                    style:
                        const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}