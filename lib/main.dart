import 'package:flutter/material.dart';

void main() {
  runApp(const HookDemo());
}

class HookDemo extends StatelessWidget {
  const HookDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String labelValue = 'Type some text.';

  void onTextFieldChanged(String textFieldValue) {
    setState(() {
      labelValue = textFieldValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
                'Enter some text in the textbox below. The label will show the text as entered.',
                style: Theme.of(context).textTheme.titleMedium),
            TextField(
              autofocus: true,
              onChanged: onTextFieldChanged,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(labelValue, style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
      ),
    );
  }
}
