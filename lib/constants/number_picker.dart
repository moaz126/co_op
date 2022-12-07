import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:co_op/constants/constants.dart';

import '../api/global_variables.dart';

class SelectHeightNumber extends StatefulWidget {
  @override
  _SelectHeightNumberState createState() => _SelectHeightNumberState();
}

class _SelectHeightNumberState extends State<SelectHeightNumber> {
  int _currentIntValue = 5;
  int _currentHorizontalIntValue = 10;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 16),
        Text('', style: Theme.of(context).textTheme.headline6),
        NumberPicker(
            value: _currentIntValue,
            minValue: 3,
            maxValue: 8,
            step: 1,
            haptics: true,
            itemHeight: 100,
            selectedTextStyle:
                GoogleFonts.bebasNeue(color: secondaryColor, fontSize: 40),
            onChanged: (value) {
              setState(() {
                _currentIntValue = value;
                select_height = value;
              });
            }),
        SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () => setState(() {
                final newValue = _currentIntValue - 1;
                _currentIntValue = newValue.clamp(70, 250);
              }),
            ),
            Text(
              '$_currentIntValue ft',
              style: GoogleFonts.bebasNeue(
                  color: secondaryColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w400),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => setState(() {
                final newValue = _currentIntValue + 1;
                _currentIntValue = newValue.clamp(70, 250);
              }),
            ),
          ],
        ),
        // Divider(color: Colors.grey, height: 32),
        // SizedBox(height: 16),
        // Text('Horizontal', style: Theme.of(context).textTheme.headline6),
        // NumberPicker(
        //   value: _currentHorizontalIntValue,
        //   minValue: 0,
        //   maxValue: 100,
        //   step: 10,
        //   itemHeight: 100,
        //   axis: Axis.horizontal,
        //   onChanged: (value) =>
        //       setState(() => _currentHorizontalIntValue = value),
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(16),
        //     border: Border.all(color: Colors.black26),
        //   ),
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     IconButton(
        //       icon: Icon(Icons.remove),
        //       onPressed: () => setState(() {
        //         final newValue = _currentHorizontalIntValue - 10;
        //         _currentHorizontalIntValue = newValue.clamp(0, 100);
        //       }),
        //     ),
        //     Text('Current horizontal int value: $_currentHorizontalIntValue'),
        //     IconButton(
        //       icon: Icon(Icons.add),
        //       onPressed: () => setState(() {
        //         final newValue = _currentHorizontalIntValue + 20;
        //         _currentHorizontalIntValue = newValue.clamp(0, 100);
        //       }),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

class SelectHeightdecimal extends StatefulWidget {
  @override
  _SelectHeightdecimalState createState() => _SelectHeightdecimalState();
}

class _SelectHeightdecimalState extends State<SelectHeightdecimal> {
  int _currentIntValue = 0;
  int _currentHorizontalIntValue = 10;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 16),
        Text('', style: Theme.of(context).textTheme.headline6),
        NumberPicker(
            value: _currentIntValue,
            minValue: 0,
            maxValue: 9,
            step: 1,
            haptics: true,
            itemHeight: 100,
            selectedTextStyle:
                GoogleFonts.bebasNeue(color: secondaryColor, fontSize: 40),
            onChanged: (value) {
              setState(() {
                _currentIntValue = value;
                select_height_decimal = value;
              });
            }),
        SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () => setState(() {
                final newValue = _currentIntValue - 1;
                _currentIntValue = newValue.clamp(70, 250);
              }),
            ),
            Text(
              '$_currentIntValue In',
              style: GoogleFonts.bebasNeue(
                  color: secondaryColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w400),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => setState(() {
                final newValue = _currentIntValue + 1;
                _currentIntValue = newValue.clamp(70, 250);
              }),
            ),
          ],
        ),
        // Divider(color: Colors.grey, height: 32),
        // SizedBox(height: 16),
        // Text('Horizontal', style: Theme.of(context).textTheme.headline6),
        // NumberPicker(
        //   value: _currentHorizontalIntValue,
        //   minValue: 0,
        //   maxValue: 100,
        //   step: 10,
        //   itemHeight: 100,
        //   axis: Axis.horizontal,
        //   onChanged: (value) =>
        //       setState(() => _currentHorizontalIntValue = value),
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(16),
        //     border: Border.all(color: Colors.black26),
        //   ),
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     IconButton(
        //       icon: Icon(Icons.remove),
        //       onPressed: () => setState(() {
        //         final newValue = _currentHorizontalIntValue - 10;
        //         _currentHorizontalIntValue = newValue.clamp(0, 100);
        //       }),
        //     ),
        //     Text('Current horizontal int value: $_currentHorizontalIntValue'),
        //     IconButton(
        //       icon: Icon(Icons.add),
        //       onPressed: () => setState(() {
        //         final newValue = _currentHorizontalIntValue + 20;
        //         _currentHorizontalIntValue = newValue.clamp(0, 100);
        //       }),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

class SelectNumber extends StatefulWidget {
  @override
  _SelectNumberState createState() => _SelectNumberState();
}

class _SelectNumberState extends State<SelectNumber> {
  int _currentIntValue = 20;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 16),
        Text('', style: Theme.of(context).textTheme.headline6),
        Container(
          height: 300,
          child: NumberPicker(
              value: _currentIntValue,
              minValue: 10,
              maxValue: 100,
              step: 1,
              haptics: true,
              itemHeight: 100,
              selectedTextStyle: GoogleFonts.bebasNeue(
                color: secondaryColor,
                fontSize: 60,
              ),
              onChanged: (value) {
                setState(() {
                  _currentIntValue = value;
                  select_age = value;
                });
              }),
        ),
        SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () => setState(() {
                final newValue = _currentIntValue - 1;
                _currentIntValue = newValue.clamp(0, 100);
              }),
            ),
            Text(
              'Age: $_currentIntValue',
              style: GoogleFonts.bebasNeue(
                  fontSize: 22,
                  color: secondaryColor,
                  fontWeight: FontWeight.w400),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => setState(() {
                final newValue = _currentIntValue + 1;
                _currentIntValue = newValue.clamp(0, 100);
              }),
            ),
          ],
        ),
        // Divider(color: Colors.grey, height: 32),
        // SizedBox(height: 16),
        // Text('Horizontal', style: Theme.of(context).textTheme.headline6),
        // NumberPicker(
        //   value: _currentHorizontalIntValue,
        //   minValue: 0,
        //   maxValue: 100,
        //   step: 10,
        //   itemHeight: 100,
        //   axis: Axis.horizontal,
        //   onChanged: (value) =>
        //       setState(() => _currentHorizontalIntValue = value),
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(16),
        //     border: Border.all(color: Colors.black26),
        //   ),
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     IconButton(
        //       icon: Icon(Icons.remove),
        //       onPressed: () => setState(() {
        //         final newValue = _currentHorizontalIntValue - 10;
        //         _currentHorizontalIntValue = newValue.clamp(0, 100);
        //       }),
        //     ),
        //     Text('Current horizontal int value: $_currentHorizontalIntValue'),
        //     IconButton(
        //       icon: Icon(Icons.add),
        //       onPressed: () => setState(() {
        //         final newValue = _currentHorizontalIntValue + 20;
        //         _currentHorizontalIntValue = newValue.clamp(0, 100);
        //       }),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

class SelectNumberHorizontal extends StatefulWidget {
  @override
  _SelectNumberHorizontalState createState() => _SelectNumberHorizontalState();
}

class _SelectNumberHorizontalState extends State<SelectNumberHorizontal> {
  int _currentHorizontalIntValue = 70;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 16),
        Text('', style: Theme.of(context).textTheme.headline6),
        NumberPicker(
          value: _currentHorizontalIntValue,
          minValue: 50,
          maxValue: 300,
          step: 1,
          haptics: true,
          axis: Axis.horizontal,
          itemHeight: 60,
          selectedTextStyle: TextStyle(
            color: secondaryColor,
            fontSize: 40,
          ),
          onChanged: (value) {
            setState(() {
              _currentHorizontalIntValue = value;
              select_weight = value;
            });
          },
        ),
        SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () => setState(() {
                final newValue = _currentHorizontalIntValue - 1;
                _currentHorizontalIntValue = newValue.clamp(0, 100);
              }),
            ),
            Text(
              'Weight: $_currentHorizontalIntValue Lb',
              style: GoogleFonts.bebasNeue(
                  fontWeight: FontWeight.w400,
                  fontSize: 22,
                  color: secondaryColor),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => setState(() {
                final newValue = _currentHorizontalIntValue + 1;
                _currentHorizontalIntValue = newValue.clamp(0, 100);
              }),
            ),
          ],
        ),
        // Divider(color: Colors.grey, height: 32),
        // SizedBox(height: 16),
        // Text('Horizontal', style: Theme.of(context).textTheme.headline6),
        // NumberPicker(
        //   value: _currentHorizontalIntValue,
        //   minValue: 0,
        //   maxValue: 100,
        //   step: 10,
        //   itemHeight: 100,
        //   axis: Axis.horizontal,
        //   onChanged: (value) =>
        //       setState(() => _currentHorizontalIntValue = value),
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(16),
        //     border: Border.all(color: Colors.black26),
        //   ),
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     IconButton(
        //       icon: Icon(Icons.remove),
        //       onPressed: () => setState(() {
        //         final newValue = _currentHorizontalIntValue - 10;
        //         _currentHorizontalIntValue = newValue.clamp(0, 100);
        //       }),
        //     ),
        //     Text('Current horizontal int value: $_currentHorizontalIntValue'),
        //     IconButton(
        //       icon: Icon(Icons.add),
        //       onPressed: () => setState(() {
        //         final newValue = _currentHorizontalIntValue + 20;
        //         _currentHorizontalIntValue = newValue.clamp(0, 100);
        //       }),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
