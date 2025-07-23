import 'package:flutter/material.dart';
import '../models/mitarbeiter_model.dart';
import '../services/mitarbeiter_service.dart';

class MitarbeiterProvider extends ChangeNotifier {
  final MitarbeiterService _service = MitarbeiterService();
  List<Mitarbeiter> _mitarbeiter = [];
  bool _isLoading = false;

  List<Mitarbeiter> get mitarbeiter => _mitarbeiter;
  bool get isLoading => _isLoading;

  Future<void> loadMitarbeiter() async {
    _isLoading = true;
    notifyListeners();
    _mitarbeiter = await _service.getMitarbeiterFromHive();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> syncMitarbeiter() async {
    _isLoading = true;
    notifyListeners();
    await _service.syncMitarbeiterFromFirestore();
    _mitarbeiter = await _service.getMitarbeiterFromHive();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> clearLocalMitarbeiter() async {
    await _service.clearHiveBox();
    _mitarbeiter = [];
    notifyListeners();
  }
}
