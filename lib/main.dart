import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'winhook.dart';

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

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  String labelValue = 'Type some text.';
  bool windowsHookEnabled = false;
  int keyboardHookHandle = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    if (kDebugMode) print('Disposing...');
    removeKeyboardHook();

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void removeKeyboardHook() {
    if (!windowsHookEnabled) return;

    clearKeyboardHook(keyboardHookHandle);
    windowsHookEnabled = false;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        if (kDebugMode) print('App paused...');
        removeKeyboardHook();
        break;
      default:
        break;
    }
  }

  @override
  Future<bool> didPopRoute() async {
    if (kDebugMode) print('Route popped...');
    removeKeyboardHook();
    return false;
  }

  void onTextFieldChanged(String textFieldValue) {
    setState(() {
      labelValue = textFieldValue;
    });
  }

  void onSwitchChanged(bool value) {
    setState(() {
      windowsHookEnabled = !windowsHookEnabled;
      if (windowsHookEnabled) {
        keyboardHookHandle = setKeyboardHook();
        if (kDebugMode) print('hook enabled');
      } else {
        clearKeyboardHook(keyboardHookHandle);
        if (kDebugMode) print('hook disabled');
      }
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
            Row(
              children: [
                const Text('Windows hook enabled: '),
                Switch(value: windowsHookEnabled, onChanged: onSwitchChanged),
              ],
            )
          ],
        ),
      ),
    );
  }
}
