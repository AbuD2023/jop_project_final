import 'package:flutter/material.dart';
import 'package:jop_project/Providers/SignUp/searcher_signin_login_provider.dart';
import 'package:jop_project/Screens/JopScreen/Home/components/home_body.dart';
import 'package:jop_project/components/background.dart';
import 'package:jop_project/l10n/l10n.dart';
import 'package:provider/provider.dart';

import '../../../size_config.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final searcherProvider = Provider.of<SearcherSigninLoginProvider>(context);
    return Background(
      height: SizeConfig.screenH! / 4.5,
      isCompany: false,
      userImage: searcherProvider.currentSearcher?.img ?? '',
      userName: searcherProvider.currentSearcher?.fullName ?? '',
      showListNotiv: true,
      title: l10n.availablejobs,
      availableJobs: 50,
      child: const HomeBody(),
    );
  }
}

class MobileHomeScreen extends StatelessWidget {
  const MobileHomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const HomeBody();
  }
}
