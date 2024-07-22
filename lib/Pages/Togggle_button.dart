import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ToggleButtonPage extends StatelessWidget {
  const ToggleButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<ToggleProvider>(
          builder: (context, toggleProvider, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Active',
                  style: TextStyle(
                    color: toggleProvider.isActive ? Colors.black : Colors.grey,
                  ),
                ),
                const SizedBox(width: 10),
                Switch(
                  value: toggleProvider.isActive,
                  onChanged: (value) {
                    toggleProvider.setActive(value);
                  },
                  activeTrackColor: Colors.green,
                  activeColor: Colors.white,
                ),
                const SizedBox(width: 10),
                Text(
                  'Inactive',
                  style: TextStyle(
                    color: toggleProvider.isActive ? Colors.grey : Colors.black,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ToggleProvider with ChangeNotifier {
  bool _isActive = false;

  bool get isActive => _isActive;

  void setActive(bool value) {
    _isActive = value;
    notifyListeners();
  }
}