// ignore_for_file: constant_identifier_names

import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:win32/win32.dart';

const LLKHF_INJECTED = 0x00000010;
const VK_A = 0x41;
const VK_B = 0x42;

int lowlevelKeyboardHookProc(int code, int wParam, int lParam) {
  if (kDebugMode) print('keyboard hookproc called');

  if (code == HC_ACTION) {
    // Windows controls this memory; don't deallocate it.
    final kbs = Pointer<KBDLLHOOKSTRUCT>.fromAddress(lParam);

    if ((kbs.ref.flags & LLKHF_INJECTED) == 0) {
      final input = calloc<INPUT>();
      input.ref.type = INPUT_KEYBOARD;
      input.ref.ki.dwFlags = (wParam == WM_KEYDOWN) ? 0 : KEYEVENTF_KEYUP;

      // Demonstrate that we're successfully intercepting codes
      if (wParam == WM_KEYUP && kbs.ref.vkCode > 0 && kbs.ref.vkCode < 128) {
        if (kDebugMode) {
          print(String.fromCharCode(kbs.ref.vkCode));
        }
      }

      // Swap 'A' with 'B' in output
      input.ref.ki.wVk = kbs.ref.vkCode == VK_A ? VK_B : kbs.ref.vkCode;
      SendInput(1, input, sizeOf<INPUT>());
      free(input);
      return -1;
    }
  }
  return CallNextHookEx(NULL, code, wParam, lParam);
}

int setKeyboardHook() {
  final keyboardHookHandle = SetWindowsHookEx(WH_KEYBOARD_LL,
      Pointer.fromFunction<CallWndProc>(lowlevelKeyboardHookProc, 0), NULL, 0);
  return keyboardHookHandle;
}

void clearKeyboardHook(int keyboardHookHandle) {
  UnhookWindowsHookEx(keyboardHookHandle);
}
