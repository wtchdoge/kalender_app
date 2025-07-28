import 'package:flutter/material.dart';
import '../models/employee_model.dart';
import '../services/employee_service.dart';

class EmployeeProvider extends ChangeNotifier {
  final EmployeeService _service = EmployeeService();
  List<Employee> _employees = [];
  bool _isLoading = false;

  List<Employee> get mitarbeiter => _employees;
  bool get isLoading => _isLoading;


  Future<void> loadMitarbeiter() async {
    _isLoading = true;
    notifyListeners();
    _employees = await _service.getEmployeeFromHive();
    _isLoading = false;
    notifyListeners();
  }


  Future<void> syncMitarbeiter() async {
    _isLoading = true;
    notifyListeners();
    await _service.syncEmployeeFromFirestore();
    _employees = await _service.getEmployeeFromHive();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> clearLocalMitarbeiter() async {
    await _service.clearEmployeeHiveBox();
    _employees = [];
    notifyListeners();
  }
}
