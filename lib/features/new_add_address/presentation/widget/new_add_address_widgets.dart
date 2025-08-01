import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:country_picker/country_picker.dart';

class CountryPickerWidget extends StatelessWidget {
  final Country? selectedCountry;
  final Function(Country) onSelect;
  final List<String> allowedCountries;
  final bool isLoading;

  const CountryPickerWidget({
    Key? key,
    required this.selectedCountry,
    required this.onSelect,
    required this.allowedCountries,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        onTap: () {
          showCountryPicker(
            context: context,
            showPhoneCode: true,
            favorite: allowedCountries,
            countryListTheme: CountryListThemeData(
              borderRadius: BorderRadius.circular(8),
              inputDecoration: InputDecoration(
                hintText: 'Search country',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            onSelect: onSelect,
          );
        },
        leading: Text(
          selectedCountry?.flagEmoji ?? '🏳️',
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(selectedCountry?.name ?? 'Select Country'),
        subtitle: selectedCountry != null
            ? Text('(+${selectedCountry?.phoneCode})')
            : null,
        trailing: const Icon(Icons.arrow_drop_down),
      ),
    );
  }
}

class PhoneNumberInput extends StatelessWidget {
  final TextEditingController controller;
  final Country? selectedCountry;
  final String? Function(String?)? validator;

  const PhoneNumberInput({
    Key? key,
    required this.controller,
    required this.selectedCountry,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Row(
            children: [
              Text(selectedCountry?.flagEmoji ?? '🏳️'),
              const SizedBox(width: 8),
              Text(selectedCountry != null
                  ? '+${selectedCountry!.phoneCode}'
                  : '+?'),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            controller: controller,
            enabled: selectedCountry != null,
            keyboardType: TextInputType.phone,
            validator: validator,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              hintText: selectedCountry?.example ?? '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RegionCityInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;

  const RegionCityInputWidget({
    Key? key,
    required this.controller,
    required this.label,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: validator,
    );
  }
}

class AddressInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final bool isOptional;

  const AddressInputWidget({
    Key? key,
    required this.controller,
    required this.label,
    this.validator,
    this.isOptional = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixText: isOptional ? '(Optional)' : null,
      ),
      validator: validator,
    );
  }
}

class ManualEntryToggle extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;

  const ManualEntryToggle({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Switch(
          value: value,
          onChanged: onChanged,
        ),
        const Text('Enter region/city manually'),
      ],
    );
  }
}
