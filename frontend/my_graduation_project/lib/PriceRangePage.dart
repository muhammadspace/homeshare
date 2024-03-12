import 'package:flutter/material.dart';

class PriceRangePage extends StatefulWidget {
  @override
  _PriceRangePageState createState() => _PriceRangePageState();
}

class _PriceRangePageState extends State<PriceRangePage> {
  double? minPrice;
  double? maxPrice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Price Range'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPriceSlider('Minimum Price', minPrice, (value) {
              setState(() {
                minPrice = value;
              });
            }),
            SizedBox(height: 20),
            _buildPriceSlider('Maximum Price', maxPrice, (value) {
              setState(() {
                maxPrice = value;
              });
            }),
            SizedBox(height: 500),
            ElevatedButton(
              onPressed: () {
                if (minPrice != null && maxPrice != null) {
                  print('Minimum Price: $minPrice');
                  print('Maximum Price: $maxPrice');
                  // You can navigate to the next page or perform other actions here
                } else {
                  print('Please select both minimum and maximum prices');
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'Continue',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSlider(String label, double? value, ValueChanged<double?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.attach_money, size: 24),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        Slider(
          value: value ?? 0,
          onChanged: onChanged,
          min: 0,
          max: 100000, // Set the maximum value according to your requirements
          divisions: 100,
          label: value != null ? '$value' : null,
        ),
      ],
    );
  }
}
