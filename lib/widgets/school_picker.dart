import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class SchoolItem {
  final String id;
  final String name;
  final String city;
  final String district;

  SchoolItem({
    required this.id,
    required this.name,
    required this.city,
    required this.district,
  });

  factory SchoolItem.fromJson(Map<String, dynamic> json) {
    return SchoolItem(
      id: json['id'] as String,
      name: json['name'] as String,
      city: (json['city'] ?? '') as String,
      district: (json['district'] ?? '') as String,
    );
  }
}

Future<List<SchoolItem>> _loadSchools() async {
  final String jsonStr = await rootBundle.loadString(
    'assets/data/tamilnadu_schools.json',
  );
  final List<dynamic> list = json.decode(jsonStr) as List<dynamic>;
  return list
      .map((e) => SchoolItem.fromJson(e as Map<String, dynamic>))
      .toList();
}

Future<SchoolItem?> showSchoolPicker(BuildContext context) async {
  final TextEditingController searchController = TextEditingController();
  List<SchoolItem> all = await _loadSchools();
  List<SchoolItem> filtered = List.of(all);

  return showModalBottomSheet<SchoolItem>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return StatefulBuilder(
            builder: (context, setState) {
              void onQueryChanged(String q) {
                final String query = q.toLowerCase().trim();
                setState(() {
                  if (query.isEmpty) {
                    filtered = List.of(all);
                  } else {
                    filtered = all.where((s) {
                      return s.name.toLowerCase().contains(query) ||
                          s.city.toLowerCase().contains(query) ||
                          s.district.toLowerCase().contains(query);
                    }).toList();
                  }
                });
              }

              return AnimatedPadding(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Select your school',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: searchController,
                        onChanged: onQueryChanged,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search by name, city, district',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: filtered.isEmpty
                            ? const Center(child: Text('No results'))
                            : ListView.builder(
                                controller: scrollController,
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  final SchoolItem item = filtered[index];
                                  return ListTile(
                                    title: Text(item.name),
                                    subtitle: Text(
                                      [
                                        item.city,
                                        item.district,
                                      ].where((e) => e.isNotEmpty).join(' • '),
                                    ),
                                    onTap: () => Navigator.pop(context, item),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
}
