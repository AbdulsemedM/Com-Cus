import 'package:commercepal/features/addresses/presentation/edit_address_page.dart';
import 'package:commercepal/features/addresses/presentation/search_places.dart';
import 'package:commercepal/features/check_out/data/models/address.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/di/injector.dart';
import '../../../../app/utils/app_colors.dart';
import '../../../addresses/presentation/add_address_page.dart';
import '../../../dashboard/widgets/home_error_widget.dart';
import '../../../dashboard/widgets/home_loading_widget.dart';
import '../bloc/check_out_cubit.dart';
import '../bloc/check_out_state.dart';

enum AddressSelectedChoices { selected, notSelcted }

class CheckOutAddressesWidget extends StatefulWidget {
  final Function onAddressClicked;

  const CheckOutAddressesWidget({Key? key, required this.onAddressClicked})
      : super(key: key);

  @override
  State<CheckOutAddressesWidget> createState() =>
      _CheckOutAddressesWidgetState();
}

class _CheckOutAddressesWidgetState extends State<CheckOutAddressesWidget> {
  final AddressSelectedChoices _addSelected = AddressSelectedChoices.notSelcted;
  void initState() {
    super.initState();
    fetchHints();
  }

  bool done = false;

  void fetchHints() async {
    setState(() {
      loading = true;
    });

    AddAddr = Translations.translatedText(
        "Add address", GlobalStrings.getGlobalString());
    Edit = Translations.translatedText("Edit", GlobalStrings.getGlobalString());
    Country = Translations.translatedText(
        "Country: ", GlobalStrings.getGlobalString());
    City =
        Translations.translatedText("City: ", GlobalStrings.getGlobalString());
    SubCounty = Translations.translatedText(
        "Sub-county: ", GlobalStrings.getGlobalString());
    ShippBill = Translations.translatedText(
        "Shipping and Billing", GlobalStrings.getGlobalString());
    FillAdd = Translations.translatedText(
        "Fill Address", GlobalStrings.getGlobalString());
    HowDo = Translations.translatedText("How do you want to fill the address?",
        GlobalStrings.getGlobalString());
    Automatic = Translations.translatedText(
        "From Map", GlobalStrings.getGlobalString());
    Manual = Translations.translatedText(
        "Manually", GlobalStrings.getGlobalString());
    Cancel =
        Translations.translatedText("Cancel", GlobalStrings.getGlobalString());

    // Use await to get the actual string value from the futures
    AAdd = await AddAddr;
    Ed = await Edit;
    Co = await Country;
    Ci = await City;
    SC = await SubCounty;
    SBill = await ShippBill;
    FAdd = await FillAdd;
    HDO = await HowDo;
    Aut = await Automatic;
    Man = await Manual;
    Can = await Cancel;
    print("herrerererere");
    print(AAdd);

    setState(() {
      loading = false;
    });
  }

  var AddAddr;
  String AAdd = '';
  var Edit;
  String Ed = '';
  var Country;
  String Co = '';
  var City;
  String Ci = '';
  var SubCounty;
  String SC = '';
  var ShippBill;
  String SBill = '';
  var FillAdd;
  String FAdd = '';
  var HowDo;
  String HDO = '';
  var Automatic;
  String Aut = '';
  var Manual;
  String Man = '';
  var Cancel;
  String Can = '';
  var loading = false;

  @override
  Widget build(BuildContext context) {
    var sHeight = MediaQuery.of(context).size.height * 1;
    return BlocProvider(
      create: (context) => getIt<CheckOutCubit>()..fetchAddresses(),
      child: BlocBuilder<CheckOutCubit, CheckOutState>(
        builder: (ctx, state) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  loading
                      ? const Text("Loading...")
                      : Text(
                          SBill,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontSize: 20.sp),
                        ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title:
                                loading ? const Text("Loading...") : Text(FAdd),
                            content: Column(
                              mainAxisSize: MainAxisSize
                                  .min, // Set the mainAxisSize to min
                              children: [
                                loading ? const Text("Loading...") : Text(HDO),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: sHeight * 0.02,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pushNamed(context,
                                                SearchPlacesScreen.routeName)
                                            .then((value) => {
                                                  ctx
                                                      .read<CheckOutCubit>()
                                                      .fetchAddresses()
                                                });
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.colorPrimaryDark),
                                      child: loading
                                          ? const Text("Loading...")
                                          : Text(
                                              Aut,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                    ),
                                    SizedBox(
                                      height: sHeight * 0.02,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pushNamed(context,
                                                AddAddressPage.routeName)
                                            .then((value) => {
                                                  ctx
                                                      .read<CheckOutCubit>()
                                                      .fetchAddresses()
                                                });
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.colorPrimaryDark),
                                      child: loading
                                          ? const Text("Loading...")
                                          : Text(
                                              Man,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(false); // User does not confirm
                                },
                                child: loading
                                    ? const Text("Loading...")
                                    : Text(
                                        Can,
                                        style: TextStyle(color: Colors.red),
                                      ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: loading
                        ? const Text("Loading...")
                        : Text(AAdd,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: AppColors.colorPrimary)),
                  ),
                ],
              ),
              const Divider(
                color: Colors.grey,
              ),
              state.maybeWhen(
                  orElse: () => const Padding(
                        padding: EdgeInsets.all(20),
                        child: HomeLoadingWidget(),
                      ),
                  error: (error) => Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: HomeErrorWidget(error: error),
                      ),
                  addresses: (adds) {
                    if (adds.isNotEmpty) {
                      // Check if the list of addresses is not empty
                      // Check if none of the addresses are selected
                      // adds[0].selected = false;
                      // AddressSelectedChoices.notSelcted;

                      if (!adds.any((address) => address.selected == true)) {
                        _markSelectedAddress(ctx, adds[0], adds);
                        // widget.onAddressClicked.call(adds[0]);
                        // adds[0].selected = true;
                        // ctx.read<CheckOutCubit>().setSelectedAddress(adds[0]);
                        print("newherewego");
                        // Set the first address as selected
                        // Dispatch the updated list of addresses to the CheckOutCubit
                      } else if (adds[0].selected && !done) {
                        // done = true;
                        widget.onAddressClicked.call(adds[0]);
                      }
                    }
                    return Column(
                      children: adds
                          .map((address) => Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: ListTile(
                                      onTap: () {
                                        _markSelectedAddress(
                                            ctx, address, adds);
                                      },
                                      leading: Radio<AddressSelectedChoices>(
                                        value: address.selected != true
                                            ? AddressSelectedChoices.selected
                                            : AddressSelectedChoices.notSelcted,
                                        groupValue: _addSelected,
                                        onChanged: (value) {
                                          _markSelectedAddress(
                                              ctx, address, adds);
                                        },
                                      ),
                                      title: Text(
                                        "${address.name}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                              text: TextSpan(children: [
                                            TextSpan(
                                                text:
                                                    loading ? "Loading..." : Co,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                        color: AppColors
                                                            .secondaryTextColor)),
                                            TextSpan(
                                                text: "${address.country}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith())
                                          ])),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          RichText(
                                              text: TextSpan(children: [
                                            TextSpan(
                                                text:
                                                    loading ? "Loading..." : Ci,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                        color: AppColors
                                                            .secondaryTextColor)),
                                            TextSpan(
                                                text: "${address.city}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith())
                                          ])),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          RichText(
                                              text: TextSpan(children: [
                                            TextSpan(
                                                text:
                                                    loading ? "Loading..." : SC,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                        color: AppColors
                                                            .secondaryTextColor)),
                                            TextSpan(
                                                text: "${address.subCounty}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith())
                                          ]))
                                        ],
                                      ),
                                      trailing: InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context,
                                                  EditAddressPage.routeName,
                                                  arguments:
                                                      address.toAddressItem())
                                              .then((value) => ctx
                                                  .read<CheckOutCubit>()
                                                  .fetchAddresses());
                                        },
                                        child: loading
                                            ? const Text("Loading...")
                                            : Text(
                                                Ed,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displaySmall
                                                    ?.copyWith(
                                                        color: AppColors
                                                            .colorPrimary,
                                                        fontSize: 16.sp),
                                              ),
                                      ),
                                    ),
                                  ),
                                  if (adds.indexOf(address) == adds.length - 1)
                                    const SizedBox(
                                      height: 100,
                                    )
                                ],
                              ))
                          .toList(),
                    );
                  })
            ],
          );
        },
      ),
    );
  }

  void _markSelectedAddress(
      BuildContext ctx, Address address, List<Address> adds) {
    ctx.read<CheckOutCubit>().markAddressAsSelected(address.id!.toInt(), adds);
    widget.onAddressClicked.call(address);
  }
}
