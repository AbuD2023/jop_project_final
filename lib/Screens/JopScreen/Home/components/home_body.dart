import 'package:flutter/material.dart';
import 'package:jop_project/Models/company_model.dart';
import 'package:jop_project/Providers/Job/job_provider.dart';
// import 'package:jop_project/Providers/Companies/companies_provider.dart';
import 'package:jop_project/Providers/SignUp/searcher_signin_login_provider.dart';
import 'package:jop_project/Screens/JopScreen/Home/components/home_list_tile_widget.dart';
import 'package:jop_project/Screens/JopScreen/Jop_Info/jop_info_screen.dart';
import 'package:jop_project/components/custom_popup_menu.dart';
import 'package:jop_project/constants.dart';
import 'package:jop_project/l10n/l10n.dart';
import 'package:jop_project/size_config.dart';
import 'package:provider/provider.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // final companyProvider = Provider.of<CompaniesProvider>(context);
    final searcherProvider = Provider.of<SearcherSigninLoginProvider>(context);
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  width: SizeConfig.screenW,
                  child: Text(
                    l10n.findjob,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: kBorderColor),
                    textAlign: TextAlign.center,
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Expanded(
                    flex: 6,
                    child: TextField(
                      controller: context.watch<JobsProvider>().controller,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      minLines: 1,
                      maxLines: 1,
                      onChanged: (value) {
                        context.read<JobsProvider>().search();
                      },
                      decoration: InputDecoration(
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 209, 209, 209),
                                width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 209, 209, 209),
                                width: 2.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                          ),
                          suffixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          hintText: l10n.search,
                          hintStyle: const TextStyle(color: Colors.grey)),
                    ),
                  ),
                  CustomPopupMenu(
                    menuItems: const [
                      'مكتبي',
                      'عن بعد',
                      'دوام جزئي',
                      'دوام كامل',
                      'بنائاً على السيرة الذاتية',
                      'الكل',
                    ],
                    onClickMenu: (item) {
                      context.read<JobsProvider>().searchPermanenceType(
                          item.menuTitle,
                          searcherProvider.currentSearcher!.id ?? 0);
                    },
                  ),
                ],
              ),
              Expanded(
                child: Consumer<JobsProvider>(
                    builder: (context, jobsProvider, child) {
                  return !jobsProvider.isLoading
                      ? jobsProvider.jobs.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: jobsProvider
                                      .jobsSearchPermanenceType.isNotEmpty
                                  ? jobsProvider.jobsSearchPermanenceType.length
                                  : jobsProvider.controller.text.isNotEmpty
                                      ? jobsProvider.jobsSearch.length
                                      : jobsProvider.jobs.length,
                              itemBuilder: (context, index) {
                                var jop = jobsProvider
                                        .jobsSearchPermanenceType.isNotEmpty
                                    ? jobsProvider
                                        .jobsSearchPermanenceType[index]
                                    : jobsProvider.controller.text.isNotEmpty
                                        ? jobsProvider.jobsSearch[index]
                                        : jobsProvider.jobs[index];

                                return !jobsProvider.isLoading
                                    ? HomeListTileWidget(
                                        companyId: jop.companyId.toString(),
                                        companyModel: jop.company ??
                                            CompanyModel(
                                              nameCompany: l10n.nothing,
                                            ),
                                        phone: (jop.company != null &&
                                                jop.company!.phone != null)
                                            ? jop.company!.phone!
                                            : (jop.company != null &&
                                                    jop.company!.phone2 != null)
                                                ? jop.company!.phone2!
                                                : l10n.nothing,
                                        icon: Icons.person,
                                        title: ((jop.company != null)
                                                ? jop.company
                                                : CompanyModel(
                                                    nameCompany: l10n.nothing,
                                                  ))!
                                            .nameCompany
                                            .toString(),
                                        subtitle: jop.nameJob.toString(),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  JopInfoScreen(
                                                jobData: jop,
                                                companyData: jop.company!,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : const Center(
                                        child: CircularProgressIndicator(),
                                      );
                              },
                            )
                          : Center(
                              child: Text(l10n.notjobs),
                            )
                      : const Center(
                          child: CircularProgressIndicator(),
                        );
                }),
              )
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                tooltip: l10n.toupdate,
                onPressed: () {
                  context.read<JobsProvider>().getJobs();
                  // context.read<JobsProvider>().getJobs();
                },
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
