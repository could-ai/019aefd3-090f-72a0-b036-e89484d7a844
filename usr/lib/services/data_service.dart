import 'package:couldai_user_app/models/technician.dart';

class DataService {
  // Singleton pattern
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  // Mock Data
  final List<Technician> _technicians = [
    Technician(id: '1', name: 'Rahul Kumar', phone: '9876543210', city: 'Delhi', country: 'India', category: 'Plumber'),
    Technician(id: '2', name: 'Amit Singh', phone: '9876543211', city: 'Mumbai', country: 'India', category: 'Electrician'),
    Technician(id: '3', name: 'Suresh Sharma', phone: '9876543212', city: 'Delhi', country: 'India', category: 'AC Technician'),
    Technician(id: '4', name: 'CleanPro Services', phone: '9876543213', city: 'Bangalore', country: 'India', category: 'Cleaning'),
    Technician(id: '5', name: 'Vikram Plumbers', phone: '9876543214', city: 'Mumbai', country: 'India', category: 'Plumber'),
    Technician(id: '6', name: 'Fast Electric', phone: '9876543215', city: 'Bangalore', country: 'India', category: 'Electrician'),
    Technician(id: '7', name: 'Cool Air Fix', phone: '9876543216', city: 'Delhi', country: 'India', category: 'AC Technician'),
    Technician(id: '8', name: 'Home Shine', phone: '9876543217', city: 'Mumbai', country: 'India', category: 'Cleaning'),
    Technician(id: '9', name: 'John Smith', phone: '1234567890', city: 'New York', country: 'USA', category: 'Plumber'),
    Technician(id: '10', name: 'Mike Johnson', phone: '1234567891', city: 'London', country: 'UK', category: 'Electrician'),
  ];

  List<Technician> getTechniciansByCategory(String category) {
    return _technicians.where((t) => t.category == category).toList();
  }

  List<String> getCities() {
    return _technicians.map((t) => t.city).toSet().toList()..sort();
  }

  List<String> getCountries() {
    return _technicians.map((t) => t.country).toSet().toList()..sort();
  }

  void addTechnician(Technician technician) {
    _technicians.add(technician);
  }
}
