import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:couldai_user_app/models/technician.dart';
import 'package:couldai_user_app/services/data_service.dart';

class CategoryListScreen extends StatefulWidget {
  final String categoryName;

  const CategoryListScreen({super.key, required this.categoryName});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final DataService _dataService = DataService();
  List<Technician> _allTechnicians = [];
  List<Technician> _filteredTechnicians = [];
  String? _selectedCity;
  String? _selectedCountry;
  List<String> _cities = [];
  List<String> _countries = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _allTechnicians = _dataService.getTechniciansByCategory(widget.categoryName);
    _cities = _dataService.getCities();
    _countries = _dataService.getCountries();
    _filterData();
  }

  void _filterData() {
    setState(() {
      _filteredTechnicians = _allTechnicians.where((t) {
        final matchesCity = _selectedCity == null || _selectedCity == 'All Cities' || t.city.toLowerCase() == _selectedCity!.toLowerCase();
        final matchesCountry = _selectedCountry == null || _selectedCountry == 'All Countries' || t.country.toLowerCase() == _selectedCountry!.toLowerCase();
        return matchesCity && matchesCountry;
      }).toList();
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not launch dialer for $phoneNumber')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error launching phone dialer')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: Column(
        children: [
          // Filters Container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.red.shade50,
            child: Column(
              children: [
                // Country Filter
                Row(
                  children: [
                    const Icon(Icons.public, color: Colors.red),
                    const SizedBox(width: 10),
                    const Text('Country: ', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButton<String>(
                        value: _selectedCountry,
                        hint: const Text('All Countries'),
                        isExpanded: true,
                        underline: Container(height: 1, color: Colors.red),
                        items: [
                          const DropdownMenuItem(
                            value: 'All Countries',
                            child: Text('All Countries'),
                          ),
                          ..._countries.map((String country) {
                            return DropdownMenuItem(
                              value: country,
                              child: Text(country),
                            );
                          }),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCountry = newValue;
                            _filterData();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // City Filter
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red),
                    const SizedBox(width: 10),
                    const Text('City:        ', style: TextStyle(fontWeight: FontWeight.bold)), // Spacing to align with Country
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButton<String>(
                        value: _selectedCity,
                        hint: const Text('All Cities'),
                        isExpanded: true,
                        underline: Container(height: 1, color: Colors.red),
                        items: [
                          const DropdownMenuItem(
                            value: 'All Cities',
                            child: Text('All Cities'),
                          ),
                          ..._cities.map((String city) {
                            return DropdownMenuItem(
                              value: city,
                              child: Text(city),
                            );
                          }),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCity = newValue;
                            _filterData();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // List
          Expanded(
            child: _filteredTechnicians.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No ${widget.categoryName}s found.',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredTechnicians.length,
                    itemBuilder: (context, index) {
                      final tech = _filteredTechnicians[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.red.shade100,
                                child: Text(
                                  tech.name[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tech.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_city, size: 14, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${tech.city}, ${tech.country}',
                                          style: TextStyle(color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => _makePhoneCall(tech.phone),
                                icon: const Icon(Icons.call),
                                color: Colors.white,
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.all(12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
