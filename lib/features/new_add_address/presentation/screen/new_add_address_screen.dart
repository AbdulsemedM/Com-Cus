import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:country_picker/country_picker.dart';
import 'package:commercepal/app/data/network/api_provider.dart';
import 'package:commercepal/app/data/network/end_points.dart';
import 'package:commercepal/features/new_add_address/model/delivery_allowed_countries.dart';
import 'package:commercepal/features/new_add_address/model/delivery_allowed_regions.dart';
import 'package:commercepal/features/new_add_address/model/delivery_allowed_cities.dart';
import 'package:commercepal/features/new_add_address/presentation/widget/new_add_address_widgets.dart';

class NewAddAddressScreen extends StatefulWidget {
  const NewAddAddressScreen({Key? key}) : super(key: key);

  @override
  State<NewAddAddressScreen> createState() => _NewAddAddressScreenState();
}

class _NewAddAddressScreenState extends State<NewAddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contactNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _aptController = TextEditingController();
  final _zipController = TextEditingController();
  final _manualRegionController = TextEditingController();
  final _manualCityController = TextEditingController();

  bool _isLoading = false;
  bool _isManualEntry = false;
  Country? _selectedCountry;
  String? _selectedRegion;
  String? _selectedCity;

  List<DeliveryAllowedCountries> _countries = [];
  List<DeliveryAllowedRegions> _regions = [];
  List<DeliveryAllowedCities> _cities = [];

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  Future<void> _fetchCountries() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiProvider(Dio()).get(EndPoints.countries.url);
      if (response['statusCode'] == '000') {
        final List<dynamic> data = response['data'];
        setState(() {
          _countries =
              data.map((e) => DeliveryAllowedCountries.fromMap(e)).toList();
          _isLoading = false;
        });
      } else {
        _showError(
            response['statusDescription'] ?? 'Failed to fetch countries');
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _fetchRegions(int countryId) async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiProvider(Dio()).get('${EndPoints.cities.url.replaceAll("cities", "regions")}?countryId=$countryId');
      if (response['statusCode'] == '000') {
        final List<dynamic> data = response['data'];
        setState(() {
          _regions = data.map((e) => DeliveryAllowedRegions.fromMap(e)).toList();
          _isLoading = false;
        });
      } else {
        _showError(response['statusDescription'] ?? 'Failed to fetch regions');
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _fetchCities(int regionId) async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiProvider(Dio()).get('${EndPoints.cities.url}?regionId=$regionId');
      if (response['statusCode'] == '000') {
        final List<dynamic> data = response['data'];
        setState(() {
          _cities = data.map((e) => DeliveryAllowedCities.fromMap(e)).toList();
          _isLoading = false;
        });
      } else {
        _showError(response['statusDescription'] ?? 'Failed to fetch cities');
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Address'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CountryPickerWidget(
                selectedCountry: _selectedCountry,
                allowedCountries: _countries
                    .where((c) => c.deliveryAllowed)
                    .map((c) => c.countryCode)
                    .toList(),
                onSelect: (Country country) {
                  setState(() {
                    _selectedCountry = country;
                    _selectedRegion = null;
                    _selectedCity = null;
                    _regions.clear();
                    _cities.clear();
                  });
                  final selectedCountryData = _countries.firstWhere(
                    (c) => c.countryCode == country.countryCode,
                    orElse: () => _countries.first,
                  );
                  _fetchRegions(selectedCountryData.id);
                },
                isLoading: _isLoading,
              ),
              const SizedBox(height: 24),
              const Text(
                'Contact Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              AddressInputWidget(
                controller: _contactNameController,
                label: 'Contact Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter contact name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              PhoneNumberInput(
                controller: _phoneController,
                selectedCountry: _selectedCountry,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  if (_selectedCountry == null) {
                    return 'Please select country first';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Address',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ManualEntryToggle(
                value: _isManualEntry,
                onChanged: (value) {
                  setState(() {
                    _isManualEntry = value;
                    if (value) {
                      _selectedRegion = null;
                      _selectedCity = null;
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              if (_isManualEntry) ...[
                RegionCityInputWidget(
                  controller: _manualRegionController,
                  label: 'Region',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter region';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                RegionCityInputWidget(
                  controller: _manualCityController,
                  label: 'City',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter city';
                    }
                    return null;
                  },
                ),
              ] else ...[
                if (_regions.isNotEmpty)
                  RegionCityInputWidget(
                    controller: TextEditingController(
                      text: _regions
                          .firstWhere(
                            (r) => r.id.toString() == _selectedRegion,
                            orElse: () => _regions.first,
                          )
                          .regionName,
                    ),
                    label: 'Region',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select region';
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 16),
                if (_cities.isNotEmpty)
                  RegionCityInputWidget(
                    controller: TextEditingController(
                      text: _cities
                          .firstWhere(
                            (c) => c.cityId.toString() == _selectedCity,
                            orElse: () => _cities.first,
                          )
                          .cityId
                          .toString(),
                    ),
                    label: 'City',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select city';
                      }
                      return null;
                    },
                  ),
              ],
              const SizedBox(height: 16),
              AddressInputWidget(
                controller: _streetController,
                label: 'Street, house/apartment/unit',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter street address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AddressInputWidget(
                controller: _aptController,
                label: 'Apt, suite, unit, etc',
                isOptional: true,
              ),
              const SizedBox(height: 16),
              AddressInputWidget(
                controller: _zipController,
                label: 'ZIP Code',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter ZIP code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          // TODO: Implement save address
                        }
                      },
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Save Address'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _contactNameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _aptController.dispose();
    _zipController.dispose();
    _manualRegionController.dispose();
    _manualCityController.dispose();
    super.dispose();
  }
}
