import 'package:commercepal/features/merchants/merchant_product_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MerchantSearchPage extends StatefulWidget {
  const MerchantSearchPage({Key? key}) : super(key: key);

  @override
  State<MerchantSearchPage> createState() => _MerchantSearchPageState();
}

class _MerchantSearchPageState extends State<MerchantSearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<Merchant> _filteredMerchants = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (value.isNotEmpty) {
      _filteredMerchants.clear();
      _fetchMerchants(value);
    } else {
      setState(() {
        _filteredMerchants = [];
      });
    }
  }

  Future<void> _fetchMerchants(String searchText) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
      Uri.https("api.commercepal.com:2096", "/prime/api/v1/merchant/search",
          {'page': '0', 'name': searchText, 'size': "100"}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var datas = jsonDecode(response.body);
    print(datas);
    if (datas['statusCode'] == '000') {
      for (var i in datas['data']['data']) {
        _filteredMerchants.add(Merchant(
          id: i['merchantId'].toString(),
          name: i['merchantName'],
        ));
      }
      setState(() {
        // _filteredMerchants =
        //     data1.map((json) => Merchant.fromJson(json)).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _filteredMerchants = [];
        _isLoading = false;
      });
      throw Exception('Failed to load merchants');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Search Merchants'),
      // ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 18, 8, 12),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search for merchants',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredMerchants.isEmpty &&
                        _searchController.text.isNotEmpty
                    ? Center(child: Text('No merchants found.'))
                    : ListView.builder(
                        itemCount: _filteredMerchants.length,
                        itemBuilder: (context, index) {
                          final merchant = _filteredMerchants[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MerchantProducPage(id: merchant.id)));
                            },
                            child: ListTile(
                              title: Text(merchant.name),
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

class Merchant {
  final String id;
  final String name;

  Merchant({required this.id, required this.name});

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      id: json['merchantId'].toString(),
      name: json['merchantName'],
    );
  }
}
