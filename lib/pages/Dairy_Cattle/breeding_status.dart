import 'package:flutter/material.dart';

class BreedingStatusDropdown extends StatefulWidget {
  final Function(String?) onStatusChanged;

  BreedingStatusDropdown({required this.onStatusChanged});

  @override
  _BreedingStatusDropdownState createState() => _BreedingStatusDropdownState();
}

class _BreedingStatusDropdownState extends State<BreedingStatusDropdown> {
  String? _selectedStatus; // Initial value for the dropdown

  // List of breeding statuses
  List<String> _breedingStatuses = [
    'Open for breeding',
    'Confirmed Pregnant',
    'Failed Insemination',
    'Postpartum',
    'Reproductive Health Issues',
    'Dry',
    'Reproductive Examination Pending',
    'Embryo Transfer',
    'Artificially Inseminated (AI)',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedStatus,
      icon: Icon(Icons.arrow_drop_down), // Dropdown arrow icon
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.black, fontSize: 16),
      decoration: InputDecoration(
        border: OutlineInputBorder(), // Optional border decoration
      ),
      validator: (value) {
        if (value == null || value.isEmpty || value == '-----select-----') {
          return 'Please select a breeding status';
        }
        return null;
      },
      onChanged: (String? newValue) {
        setState(() {
          _selectedStatus = newValue;
        });
        widget.onStatusChanged(newValue); // Call the callback function
      },
      items: _breedingStatuses.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}