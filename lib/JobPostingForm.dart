import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

void main() {
  runApp(MaterialApp(
    home: JobPostingForm(),
  ));
}

class JobPostingForm extends StatefulWidget {
  @override
  _JobPostingFormState createState() => _JobPostingFormState();
}

class _JobPostingFormState extends State<JobPostingForm> {
  final _formKey = GlobalKey<FormState>();
  final databaseReference = FirebaseDatabase.instance.reference();

  TextEditingController _jobTitleController = TextEditingController();
  TextEditingController _jobDescriptionController = TextEditingController();
  TextEditingController _companyInfoController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _imageUrlController = TextEditingController();
  String? _employmentType;
  TextEditingController _requiredQualificationsController =
  TextEditingController();
  TextEditingController _preferredQualificationsController =
  TextEditingController();
  TextEditingController _salaryRangeController = TextEditingController();
  TextEditingController _benefitsController = TextEditingController();
  DateTime? _deadline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Job',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white), // Set icon color to white
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _jobTitleController,
                    decoration: InputDecoration(labelText: 'Job Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter job title';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _jobDescriptionController,
                    decoration:
                    InputDecoration(labelText: 'Job Description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter job description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _companyInfoController,
                    decoration:
                    InputDecoration(labelText: 'Company'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter company information';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(labelText: 'Location'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter job location';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: InputDecoration(labelText: 'Image URL'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid Image URL';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    value: _employmentType,
                    decoration:
                    InputDecoration(labelText: 'Employment Type'),
                    onChanged: (value) {
                      setState(() {
                        _employmentType = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select employment type';
                      }
                      return null;
                    },
                    items: <String>[
                      'Full time',
                      'Part time',
                      'Contract',
                      'Internship',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _requiredQualificationsController,
                    decoration: InputDecoration(
                        labelText: 'Required Qualifications'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter required qualifications';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _preferredQualificationsController,
                    decoration: InputDecoration(
                        labelText: 'Preferred Qualifications'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter preferred qualifications';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _salaryRangeController,
                    decoration: InputDecoration(labelText: 'Salary Range'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter salary range';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _benefitsController,
                    decoration: InputDecoration(labelText: 'Benefits'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter benefits';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  ListTile(
                    title: Text('Deadline'),
                    subtitle: _deadline == null
                        ? null
                        : Text('${_deadline!.toLocal()}'.split(' ')[0]),
                    onTap: () {
                      _selectDeadline(context);
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _saveJobPosting();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFFd94242)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDeadline(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _deadline) {
      setState(() {
        _deadline = picked;
      });
    }
  }

  void _saveJobPosting() {
    databaseReference.child("jobposting").push().set({
      'jobTitle': _jobTitleController.text,
      'jobDescription': _jobDescriptionController.text,
      'companyInfo': _companyInfoController.text,
      'location': _locationController.text,
      'employmentType': _employmentType,
      'requiredQualifications': _requiredQualificationsController.text,
      'preferredQualifications': _preferredQualificationsController.text,
      "salaryRange": _salaryRangeController.text,
      "benefits": _benefitsController.text,
      'deadline': _deadline?.toIso8601String(),
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Job posting created successfully')));
      // Clear controllers after submission
      _jobTitleController.clear();
      _jobDescriptionController.clear();
      // Clear other controllers as well
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create job posting: $error')));
    });
  }
}
