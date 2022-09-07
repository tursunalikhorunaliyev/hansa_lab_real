class SendCheckSwitcher {
  bool checkSwitch = true;

  setBool(bool checkSwitchP) {
    checkSwitch = checkSwitchP;
  }

  bool get getBool => checkSwitch;
}
