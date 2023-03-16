import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maketplace/keys_model.dart';
import 'package:maketplace/quote/quote_viewmodel.dart';
import 'package:stacked_hooks/stacked_hooks.dart' show StackedHookView;

class PDFDownloadButton extends StackedHookView<QuoteViewModel> {
  const PDFDownloadButton({Key? key}) : super(key: key, reactive: true);

  @override
  Widget builder(
    BuildContext context,
    QuoteViewModel viewModel,
  ) {
    return Builder(
      builder: (BuildContext context) {
        if (viewModel.quote.detail != null) {
          return Column(
            children: [
              Row(
                children: [
                  Container(
                      width: 115,
                      decoration: BoxDecoration(
                        color: AppKeys().customColors!.white,
                        borderRadius: const BorderRadius.all(Radius.circular(200.0)),
                        border: Border.all(color: AppKeys().customColors!.WBY, width: 1.0, style: BorderStyle.solid),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: const BorderRadius.all(Radius.circular(200)),
                          hoverColor: AppKeys().customColors!.yellowLight,
                          onTap: () async {
                            return viewModel.generatePdf();
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Icon(
                                  Icons.cloud_download_outlined,
                                  size: 24,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'PDF',
                                  style: GoogleFonts.inter(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: AppKeys().customColors!.dark,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class PDFDownloadButtonMobile extends StackedHookView<QuoteViewModel> {
  const PDFDownloadButtonMobile({Key? key}) : super(key: key, reactive: true);

  @override
  Widget builder(
    BuildContext context,
    QuoteViewModel viewModel,
  ) {
    return Builder(
      builder: (BuildContext context) {
        if (viewModel.quote.detail != null) {
          return Column(
            children: [
              Row(
                children: [
                  Container(
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppKeys().customColors!.white,
                        borderRadius: const BorderRadius.all(Radius.circular(200.0)),
                        border: Border.all(color: AppKeys().customColors!.WBY, width: 1.0, style: BorderStyle.solid),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: const BorderRadius.all(Radius.circular(200)),
                          hoverColor: AppKeys().customColors!.yellowLight,
                          onTap: () async {
                            return viewModel.generatePdf();
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Icon(
                                  Icons.cloud_download_outlined,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
