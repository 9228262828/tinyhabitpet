class SoundService {
  bool _enabled = true;

  Future<void> initialize() async {}

  void setEnabled(bool value) {
    _enabled = value;
  }

  Future<void> playTap() async {
    if (!_enabled) return;
  }

  Future<void> playSuccess() async {
    if (!_enabled) return;
  }

  Future<void> playReward() async {
    if (!_enabled) return;
  }

  Future<void> dispose() async {}
}
