import 'package:flutter/material.dart';

import '../models/student_profile.dart';

class ProfileScreen extends StatefulWidget {
  final StudentProfile? profile;

  const ProfileScreen({
    super.key,
    this.profile,
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController rollNumberController =
      TextEditingController();

  final TextEditingController departmentController =
      TextEditingController();

  final TextEditingController yearController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.profile != null) {
      nameController.text =
          widget.profile!.name;

      rollNumberController.text =
          widget.profile!.rollNumber;

      departmentController.text =
          widget.profile!.department;

      yearController.text =
          widget.profile!.year;
    }
  }

  void saveProfile() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final StudentProfile profile =
        StudentProfile(
      name: nameController.text.trim(),
      rollNumber:
          rollNumberController.text.trim(),
      department:
          departmentController.text.trim(),
      year: yearController.text.trim(),
    );

    Navigator.pop(
      context,
      profile,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    rollNumberController.dispose();
    departmentController.dispose();
    yearController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // Profile icon
              Center(
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor:
                      Theme.of(context)
                          .colorScheme
                          .primaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 65,
                    color: Theme.of(context)
                        .colorScheme
                        .primary,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'Student Information',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // Student Name
              const Text(
                'Student Name',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: nameController,
                decoration:
                    const InputDecoration(
                  hintText: 'Enter your name',
                  border:
                      OutlineInputBorder(),
                  prefixIcon:
                      Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter your name';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Roll Number
              const Text(
                'Roll Number',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller:
                    rollNumberController,
                decoration:
                    const InputDecoration(
                  hintText:
                      'Enter your roll number',
                  border:
                      OutlineInputBorder(),
                  prefixIcon:
                      Icon(Icons.badge),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter your roll number';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Department
              const Text(
                'Department',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller:
                    departmentController,
                decoration:
                    const InputDecoration(
                  hintText:
                      'Example: Information Technology',
                  border:
                      OutlineInputBorder(),
                  prefixIcon:
                      Icon(Icons.school),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter your department';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Year
              const Text(
                'Year',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: yearController,
                decoration:
                    const InputDecoration(
                  hintText:
                      'Example: 3rd Year',
                  border:
                      OutlineInputBorder(),
                  prefixIcon:
                      Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter your year';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 35),

              // Save Profile Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: saveProfile,
                  icon: const Icon(
                    Icons.save,
                  ),
                  label: const Text(
                    'SAVE PROFILE',
                    style: TextStyle(
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