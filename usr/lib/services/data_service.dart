import 'package:couldai_user_app/models/technician.dart';

class DataService {
  // Singleton pattern
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  // Mock Data
  final List<Technician> _technicians = [
    Technician(id: '1', name: 'Rahul Kumar', phone: '9876543210', city: 'Delhi', category: 'Plumber'),
    Technician(id: '2', name: 'Amit Singh', phone: '9876543211', city: 'Mumbai', category: 'Electrician'),
    Technician(id: '3', name: 'Suresh Sharma', phone: '9876543212', city: 'Delhi', category: 'AC Technician'),
    Technician(id: '4', name: 'CleanPro Services', phone: '9876543213', city: 'Bangalore', category: 'Cleaning'),
    Technician(id: '5', name: 'Vikram Plumbers', phone: '9876543214', city: 'Mumbai', category: 'Plumber'),
    Technician(id: '6', name: 'Fast Electric', phone: '9876543215', city: 'Bangalore', category: 'Electrician'),
    Technician(id: '7', name: 'Cool Air Fix', phone: '9876543216', city: 'Delhi', category: 'AC Technician'),
    Technician(id: '8', name: 'Home Shine', phone: '9876543217', city: 'Mumbai', category: 'Cleaning'),
  ];

  List<Technician> getTechniciansByCategory(String category) {
    return _technicians.where((t) => t.category == category).toList();
  }

  List<String> getCities() {
    return _technicians.map((t) => t.city).toSet().toList()..sort();
  }

  void addTechnician(Technician technician) {
    _technicians.add(technician);
  }
}
