import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:profiler/bloc/profile/profile_bloc.dart';
import 'package:profiler/models/profile.dart';
import 'components/home_header.dart';
import 'components/profile_tile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final PagingController<int, Profile> _pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    context.read<ProfileBloc>().add(ProfileFetch(pageKey: pageKey));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 150, vertical: 100),
          child: Column(
            children: [
              const HomeHeader(),
              const SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 900,
                      child: BlocListener<ProfileBloc, ProfileState>(
                        listener: (context, state) {
                          if (state is ProfileLoaded) {
                            try {
                              if (state.isLastPage) {
                                _pagingController.appendLastPage(state.profiles);
                              } else {
                                final nextPageKey = state.pageKey + state.profiles.length;
                                _pagingController.appendPage(state.profiles, nextPageKey);
                              }
                            } catch (error) {
                              _pagingController.error = error;
                            }
                          }
                        },
                        child: PagedListView<int, Profile>(
                          pagingController: _pagingController,
                          builderDelegate: PagedChildBuilderDelegate<Profile>(
                            itemBuilder: (context, item, index) => ProfileTile(
                              firstName: item.firstName,
                              lastName: item.lastName,
                              email: item.email,
                              userName: item.userName,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 50),
                      height: 880,
                      width: 600,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          Text('ChatBot', style: GoogleFonts.jost(fontSize: 42)),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                            width: double.infinity,
                            height: 550,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 450,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText: 'Type your message...',
                                    contentPadding: const EdgeInsets.all(24),
                                    hintStyle: GoogleFonts.poppins(fontSize: 21),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 200,
                                height: 70,
                                child: FilledButton.tonal(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(Colors.purpleAccent[50]),
                                    shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                                  ),
                                  child: Text('Send', style: GoogleFonts.poppins(fontSize: 26)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
