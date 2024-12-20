import 'package:flutter/material.dart';
import '../services/leave_service.dart';
import './leave_history.dart';

class LeaveRequestDialog extends StatefulWidget {
  const LeaveRequestDialog({super.key});

  @override
  State<LeaveRequestDialog> createState() => _LeaveRequestDialogState();
}

class _LeaveRequestDialogState extends State<LeaveRequestDialog> {
  final _formKey = GlobalKey<FormState>();
  LeaveType _selectedType = LeaveType.vacation;
  DateTime? _startDate;
  DateTime? _endDate;
  final _reasonController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          // Reset end date if it's before start date
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
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
                  'Request Leave',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Leave Type Dropdown
                DropdownButtonFormField<LeaveType>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Leave Type',
                    border: OutlineInputBorder(),
                  ),
                  items: LeaveType.values.map((type) {
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

                // Date Selection
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: 'Start Date',
                          border: OutlineInputBorder(),
                        ),
                        controller: TextEditingController(
                          text: _startDate == null
                              ? ''
                              : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                        ),
                        onTap: () => _selectDate(context, true),
                        validator: (value) {
                          if (_startDate == null) {
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
                          labelText: 'End Date',
                          border: OutlineInputBorder(),
                        ),
                        controller: TextEditingController(
                          text: _endDate == null
                              ? ''
                              : '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                        ),
                        onTap: () => _selectDate(context, false),
                        validator: (value) {
                          if (_endDate == null) {
                            return 'Required';
                          }
                          if (_startDate != null &&
                              _endDate!.isBefore(_startDate!)) {
                            return 'Invalid date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
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
                                await LeaveService.submitLeaveRequest(
                                  LeaveRequest(
                                    employeeId: 'EMP001', // TODO: Get from auth
                                    type: _selectedType,
                                    startDate: _startDate!,
                                    endDate: _endDate!,
                                    reason: _reasonController.text,
                                  ),
                                );

                                if (context.mounted) {
                                  Navigator.of(context).pop(true);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Leave request submitted successfully!'),
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
                    // After the submit button in your LeaveRequestDialog
const SizedBox(height: 24),
const Divider(),
const SizedBox(height: 16),
const Text(
  'Recent Leave Requests',
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),
const SizedBox(height: 16),
const LeaveHistory(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}