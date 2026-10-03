import 'package:e_chat_app/core/local/country_code_local_source/domain/entities/country_code.dart';
import 'package:e_chat_app/features/auth/shared/widgets/phone_input/logic/country_code_cubit.dart';
import 'package:e_chat_app/features/auth/shared/widgets/phone_input/logic/country_code_state.dart';
import 'package:e_chat_app/features/auth/shared/widgets/phone_input/widget/country_picker.dart';
import 'package:e_chat_app/features/chats/ui/add_friend/logic/add_friend_cubit.dart';
import 'package:e_chat_app/features/chats/ui/add_friend/widgets/add_friend_phone_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddFriendPhoneInputWidget extends StatelessWidget {
  const AddFriendPhoneInputWidget({super.key});

  Future<void> _pickCountry(BuildContext context) async {
    final cubit = context.read<CountryCodeCubit>();
    final picked = await showDialog<CountryCode>(
      context: context,
      builder: (_) => CountryPickerDialog(
        countries: cubit.state.countries ?? const [],
        selectedCountry: cubit.state.countryCode,
      ),
    );
    if (picked != null) cubit.getCountryByCode(picked.code);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CountryCodeCubit, CountryCodeState>(
      listenWhen: (previous, current) =>
          previous.countryCode?.dialCode != current.countryCode?.dialCode,
      listener: (context, state) {
        final country = state.countryCode;
        if (country == null) return;
        // The typed number now belongs to another country; search it again.
        final cubit = context.read<AddFriendCubit>();
        cubit.search(dialCode: country.dialCode, number: cubit.state.number);
      },
      buildWhen: (previous, current) =>
          previous.countryCode?.code != current.countryCode?.code,
      builder: (context, state) {
        final country = state.countryCode;
        if (country == null) return SizedBox(height: 56.h);

        return AddFriendPhoneInput(
          countryCode: country.code,
          dialCode: country.dialCode,
          onCountryTap: () => _pickCountry(context),
          onChanged: (number) => context
              .read<AddFriendCubit>()
              .search(dialCode: country.dialCode, number: number),
        );
      },
    );
  }
}
