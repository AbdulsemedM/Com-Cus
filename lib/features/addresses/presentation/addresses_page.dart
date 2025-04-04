import 'package:commercepal/app/di/injector.dart';
import 'package:commercepal/features/addresses/presentation/bloc/address_cubit.dart';
import 'package:commercepal/features/addresses/presentation/bloc/address_state.dart';
import 'package:commercepal/features/dashboard/widgets/home_error_widget.dart';
import 'package:commercepal/features/dashboard/widgets/home_loading_widget.dart';
import 'package:commercepal/features/translation/get_lang.dart';
import 'package:commercepal/features/translation/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/addresses-core/data/dto/addresses_dto.dart';
import 'add_address_page.dart';
import 'widgets/address_item_widget.dart';

class AddressesPage extends StatefulWidget {
  static const routeName = "/addresses_page";

  const AddressesPage({Key? key}) : super(key: key);

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddressCubit>()..fetchAddresses(),
      child: BlocConsumer<AddressCubit, AddressState>(
        listener: (ctx, state) {
          // probably not needed, force refresh list incase of a delete
          if (state is AddressStateData) {
            setState(() {});
          }
        },
        builder: (context, state) {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: FutureBuilder<String>(
                  future: Translations.translatedText(
                      "Your Addresses", GlobalStrings.getGlobalString()),
                  //  translatedText("Log Out", 'en', dropdownValue),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Text(
                        snapshot.data ?? 'Default Text',
                        style: Theme.of(context).textTheme.titleMedium,
                      );
                    } else {
                      return Text(
                        'Loading...',
                        style: Theme.of(context).textTheme.titleMedium,
                      ); // Or any loading indicator
                    }
                  },
                ),
                centerTitle: false,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AddAddressPage.routeName)
                          .then((value) =>
                              context.read<AddressCubit>().fetchAddresses());
                    },
                    child: FutureBuilder<String>(
                      future: Translations.translatedText(
                          "Add", GlobalStrings.getGlobalString()),
                      //  translatedText("Log Out", 'en', dropdownValue),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Text(
                            snapshot.data ?? 'Default Text',
                          );
                        } else {
                          return Text(
                            'Loading...',
                          ); // Or any loading indicator
                        }
                      },
                    ),
                  )
                ],
              ),
              body: state.maybeWhen(
                  orElse: () => const HomeLoadingWidget(),
                  error: (error) => HomeErrorWidget(error: error),
                  loading: () => const HomeLoadingWidget(),
                  data: (List<AddressItem> data) {
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (ctx, index) => AddressItemWidget(
                              address: data[index],
                              onRefresh: () {
                                context
                                    .read<AddressCubit>()
                                    .removeFromAddress(data[index].id!);
                              },
                            ));
                  }));
        },
      ),
    );
  }
}
