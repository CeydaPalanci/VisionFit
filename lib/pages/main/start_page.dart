import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visio_fit/utils/router.dart';
import 'package:visio_fit/utils/theme.dart';
import 'package:visio_fit/viewmodels/start_viewmodel.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StartViewModel(),
      child: const StartPageContent(),
    );
  }
}

class StartPageContent extends StatefulWidget {
  const StartPageContent({super.key});

  @override
  State<StartPageContent> createState() => _StartPageContentState();
}

class _StartPageContentState extends State<StartPageContent>
    with TickerProviderStateMixin {
  late StartViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<StartViewModel>();
    _viewModel.initializeAnimations(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor,
              AppTheme.accentColor, // Mavi
              AppTheme.secondaryColor, // Turkuaz
              // Pembe
            ],
            stops: const [
              0.0,
              0.5,
              1.0
            ], // Renklerin eşit aralıklarla dağılması için
          ),
        ),
        child: Consumer<StartViewModel>(
          builder: (context, viewModel, child) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SlideTransition(
                      position: viewModel.firstSlideAnimation,
                      child: FadeTransition(
                        opacity: viewModel.firstTextAnimation,
                        child: Text(
                          viewModel.texts[0],
                          style:
                              Theme.of(context).textTheme.displayLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SlideTransition(
                      position: viewModel.secondSlideAnimation,
                      child: FadeTransition(
                        opacity: viewModel.secondTextAnimation,
                        child: Text(
                          viewModel.texts[1],
                          style:
                              Theme.of(context).textTheme.displayLarge?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 70),
                    
                    Container(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRouter.camera);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          'Take a selfie',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
