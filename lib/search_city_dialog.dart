import 'package:flutter/material.dart';

class SearchCityDialog extends StatefulWidget {
  const SearchCityDialog({super.key});

  @override
  _SearchCityDialogState createState() => _SearchCityDialogState();
}

class _SearchCityDialogState extends State<SearchCityDialog> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearchButtonPressed() {
    // Get the city name from the TextField
    String cityName = _searchController.text;
    // Close the dialog
    Navigator.pop(context, cityName);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Search City',
        style: TextStyle(
            fontSize: 21.0, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      content: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          labelText: 'City',
        ),
        style: const TextStyle(
            fontSize: 19.0, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      actions: [
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.green; // Set color when button is pressed
                }
                return Colors.black; // Set default color
              },
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.green; // Set color when button is pressed
                }
                return Colors.black; // Set default color
              },
            ),
          ),
          onPressed: _onSearchButtonPressed,
          child: const Text('Search',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ),
      ],
      backgroundColor: Colors.blueGrey.withOpacity(0.9),
    );
  }
}
