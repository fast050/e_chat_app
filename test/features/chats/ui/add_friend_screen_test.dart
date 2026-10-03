import 'package:e_chat_app/core/local/country_code_local_source/domain/entities/country_code.dart';
import 'package:e_chat_app/core/local/country_code_local_source/domain/repo/countries_code_repository.dart';
import 'package:e_chat_app/features/auth/shared/widgets/phone_input/logic/country_code_cubit.dart';
import 'package:e_chat_app/features/chats/domain/entities/friend.dart';
import 'package:e_chat_app/features/chats/ui/add_friend_screen.dart';
import 'package:e_chat_app/features/chats/ui/logic/add_friend_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_repositories.dart';
import '../../../helpers/pump_app.dart';

class MockCountriesCodeRepository extends Mock
    implements CountriesCodeRepository {}

void main() {
  testWidgets('typing a number lists matching users, who can then be added',
      (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final uk = CountryCode(
      name: 'United Kingdom',
      code: 'GB',
      flag: '',
      dialCode: '+44',
    );
    final countriesRepo = MockCountriesCodeRepository();
    when(() => countriesRepo.getCountriesCodes()).thenAnswer((_) async => [uk]);
    when(() => countriesRepo.getCountryByDialCode(
        dialCode: any(named: 'dialCode'))).thenAnswer((_) async => uk);

    final friendsRepo = MockFriendsRepository();
    when(() => friendsRepo.searchByPhone('+44509285'))
        .thenAnswer((_) async => const [
              Friend(id: '6', name: 'Cayla Rath', phoneNumber: '+445092852731'),
            ]);
    when(() => friendsRepo.addFriend('6')).thenAnswer((_) async {});

    final addFriendCubit = AddFriendCubit(friendsRepo);
    final countryCubit = CountryCodeCubit(countriesRepo);
    addTearDown(addFriendCubit.close);
    addTearDown(countryCubit.close);

    await tester.pumpApp(MultiBlocProvider(
      providers: [
        BlocProvider.value(value: addFriendCubit),
        BlocProvider.value(value: countryCubit),
      ],
      child: const AddFriendScreen(),
    ));
    await tester.pumpAndSettle();

    expect(find.text('(+44)'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '509285');
    await tester.pumpAndSettle();

    expect(find.text('Cayla Rath'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.person_add_alt_1_outlined));
    await tester.pumpAndSettle();

    verify(() => friendsRepo.addFriend('6')).called(1);
    expect(find.byIcon(Icons.check), findsOneWidget);
  });
}
