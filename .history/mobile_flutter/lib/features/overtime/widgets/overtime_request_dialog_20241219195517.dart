import 'package:flutter/material.dart';
import '../../../data/services/overtime_service.dart';
import 'overtime_history.dart';

class OvertimeRequestDialog extends StatefulWidget {
  const OvertimeRequestDialog({super.key});

  @override
  State<OvertimeRequestDialog> createState() => _OvertimeRequestDialogState();
}

class _OvertimeRequestDialogState extends State<OvertimeRequestDialog> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  OvertimeType _selectedType = OvertimeType.regular;
  final _reasonController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 7)), // Allow past week
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Request Overtime',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Date Selection
                TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(
                    text: _selectedDate == null
                        ? ''
                        : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  ),
                  onTap: () => _selectDate(context),
                  validator: (value) {
                    if (_selectedDate == null) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Time Selection
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Start Time',
                          border: OutlineInputBorder(),
                        ),
                        controller: TextEditingController(
                          text: _startTime?.format(context) ?? '',
                        ),
                        onTap: () => _selectTime(context, true),
                        validator: (value) {
                          if (_startTime == null) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'End Time',
                          border: OutlineInputBorder(),
                        ),
                        controller: TextEditingController(
                          text: _endTime?.format(context) ?? '',
                        ),
                        onTap: () => _selectTime(context, false),
                        validator: (value) {
                          if (_endTime == null) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Overtime Type Dropdown
                DropdownButtonFormField<OvertimeType>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Overtime Type',
                    border: OutlineInputBorder(),
                  ),
                  items: OvertimeType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.toString().split('.').last.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Reason TextField
                TextFormField(
                  controller: _reasonController,
                  decoration: const InputDecoration(
                    labelText: 'Reason',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a reason';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });

                              try {
                                await OvertimeService.submitOvertimeRequest(
                                  OvertimeRequest(
                                    employeeId: 'EMP001', // TODO: Get from auth
                                    date: _selectedDate!,
                                    startTime: _startTime!,
                                    endTime: _endTime!,
                                    type: _selectedType,
                                    reason: _reasonController.text,
                                  ),
                                );

                                if (context.mounted) {
                                  Navigator.of(context).pop(true);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Overtime request submitted successfully!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error submitting request: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } finally {
                                if (mounted) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B2C91),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Submit Request'),
                  ),
                ),
  const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Recent Overtime Requests',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const OvertimeHistory(),  // This line u

              ],
            ),
          ),
        ),
      ),
    );
  }
}