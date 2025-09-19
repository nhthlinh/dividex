import 'package:Dividex/config/l10n/app_localizations.dart';
import 'package:Dividex/shared/widgets/simple_layout.dart';
import 'package:flutter/material.dart';

class TermsOfServicePage extends StatefulWidget {
  const TermsOfServicePage({super.key});

  @override
  State<TermsOfServicePage> createState() => _TermsOfServicePageState();
}

class _TermsOfServicePageState extends State<TermsOfServicePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final intl = AppLocalizations.of(context)!; // Get the localization instance

    final effectiveDate = 'July 30, 2025'; // Placeholder for effective date
    final lastUpdatedDate = 'July 30, 2025'; // Placeholder for last

    // Define common text styles for better readability and consistency
    final textTheme = Theme.of(context).textTheme;
    final titleMedium = textTheme.titleMedium;
    final titleSmall = textTheme.titleSmall;
    final bodySmall = textTheme.bodySmall;

    return SimpleLayout(
      title: intl.termsOfServiceTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DIVIDEX Sports Hub title
          Center(
            // Centered the main title
            child: Text(intl.dIVIDEXApp, style: titleMedium),
          ),
          const SizedBox(height: 8.0),
          Center(
            child: Text(intl.version('1.0'), style: bodySmall),
          ), // Centered version
          Center(
            child: Text(intl.effectiveDate(effectiveDate), style: bodySmall),
          ), // Centered effective date
          const SizedBox(height: 24.0),

          // Section 1: Acceptance of Terms
          Text(intl.acceptanceOfTerms, style: titleMedium),
          const SizedBox(height: 8.0),
          Text(intl.welcomeMessage, style: bodySmall),
          const SizedBox(height: 4.0),
          Text(intl.agreementText, style: bodySmall),
          const SizedBox(height: 4.0),
          Text(intl.disagreementText, style: bodySmall),
          const SizedBox(height: 24.0),

          // Section 2: Service Description
          Text(intl.serviceDescription, style: titleMedium),
          const SizedBox(height: 8.0),
          Text(intl.dIVIDEXDescription, style: bodySmall),
          const SizedBox(height: 8.0),
          _buildBulletPoint(context, intl.createGroups),
          _buildBulletPoint(context, intl.trackExpenses),
          _buildBulletPoint(context, intl.socialInteractions),
          _buildBulletPoint(context, intl.splitPayments),
          _buildBulletPoint(context, intl.sendReminders),
          _buildBulletPoint(context, intl.generateReports),
          _buildBulletPoint(context, intl.receiveNotifications),
          const SizedBox(height: 24.0),

          // Section 3: Account Registration and Security
          Text(
            intl.accountRegistrationSecurity,
            style: titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Text(intl.registrationRequirements, style: titleSmall),
          const SizedBox(height: 8.0),
          _buildBulletPoint(context, intl.ageRequirement),
          _buildBulletPoint(context, intl.accurateInfo),
          _buildBulletPoint(context, intl.oneUniqueAccount),
          _buildBulletPoint(context, intl.emailVerification),
          const SizedBox(height: 16.0),
          Text(intl.accountSecurity, style: titleSmall),
          const SizedBox(height: 8.0),
          _buildBulletPoint(context, intl.passwordProtection),
          _buildBulletPoint(context, intl.unauthorizedUse),
          _buildBulletPoint(context, intl.noSharingResponsibility),
          const SizedBox(height: 24.0),

          // Section 4: Use of Service
          Text(intl.useOfService, style: titleMedium),
          const SizedBox(height: 8.0),
          Text(intl.grantedRights, style: titleSmall),
          const SizedBox(height: 8.0),
          _buildBulletPoint(context, intl.limitedRight),
          _buildBulletPoint(context, intl.accessUsePersonal),
          _buildBulletPoint(context, intl.manageShareExpenses),
          const SizedBox(height: 16.0),
          Text(intl.usageRestrictions, style: titleSmall),
          const SizedBox(height: 8.0),
          Text(intl.mayNot, style: bodySmall),
          _buildBulletPoint(context, intl.illegalPurposes),
          _buildBulletPoint(context, intl.fakeAccounts),
          _buildBulletPoint(context, intl.spamHarass),
          _buildBulletPoint(context, intl.manipulateData),
          _buildBulletPoint(context, intl.botsScripts),
          _buildBulletPoint(context, intl.hackSabotage),
          const SizedBox(height: 24.0),

          // Section 5: User Content
          Text(intl.userContent, style: titleMedium),
          const SizedBox(height: 8.0),
          Text(intl.contentOwnership, style: titleSmall),
          const SizedBox(height: 8.0),
          _buildBulletPoint(context, intl.retainOwnership),
          _buildBulletPoint(context, intl.dIVIDEXContentRights),
          const SizedBox(height: 16.0),
          Text(intl.contentStandards, style: titleSmall),
          const SizedBox(height: 8.0),
          Text(intl.mustNot, style: bodySmall),
          _buildBulletPoint(context, intl.falseInfo),
          _buildBulletPoint(context, intl.violatePrivacy),
          _buildBulletPoint(context, intl.offensiveContent),
          _buildBulletPoint(context, intl.unauthorizedAdvertising),
          _buildBulletPoint(context, intl.sharePersonalWithoutConsent),
          const SizedBox(height: 16.0),
          Text(intl.moderationRights, style: titleSmall),
          const SizedBox(height: 8.0),
          _buildBulletPoint(context, intl.reviewRemoveContent),
          _buildBulletPoint(context, intl.moderationDecisionsFinal),
          const SizedBox(height: 24.0),

          // Section 6: Privacy and Data Protection
          Text(intl.privacyDataProtection, style: titleMedium),
          const SizedBox(height: 8.0),
          Text(intl.informationCollection, style: titleSmall),
          const SizedBox(height: 8.0),
          Text(intl.collectProcessInfo, style: bodySmall),
          _buildBulletPoint(context, intl.profileInfo),
          _buildBulletPoint(context, intl.expenseData),
          _buildBulletPoint(context, intl.appUsageInfo),
          const SizedBox(height: 16.0),
          Text(intl.informationSharing, style: titleSmall),
          const SizedBox(height: 8.0),
          _buildBulletPoint(context, intl.infoDisplayedPublicly),
          _buildBulletPoint(context, intl.noSellToThirdParties),
          _buildBulletPoint(context, intl.sharedWithPartners),
          const SizedBox(height: 24.0),

          // Section 7: Free and Paid Features
          Text(intl.freePaidFeatures, style: titleMedium),
          const SizedBox(height: 8.0),
          Text(intl.freeFeatures, style: titleSmall),
          const SizedBox(height: 8.0),
          Text(intl.basicFeaturesFree, style: bodySmall),
          _buildBulletPoint(context, intl.createGroupsExpenses),
          _buildBulletPoint(context, intl.basicSplitPayments),
          _buildBulletPoint(context, intl.sendReminders),
          _buildBulletPoint(context, intl.basicReports),
          const SizedBox(height: 16.0),
          Text(intl.paidFeatures, style: titleSmall),
          const SizedBox(height: 8.0),
          _buildBulletPoint(context, intl.premiumFeaturesPayment),
          _buildBulletPoint(context, intl.transactionsNotified),
          _buildBulletPoint(context, intl.refundPolicyPublished),
          const SizedBox(height: 24.0),

          // Section 8: Intellectual Property
          Text(intl.intellectualProperty, style: titleMedium),
          const SizedBox(height: 8.0),
          Text(intl.dIVIDEXsRights, style: titleSmall),
          const SizedBox(height: 8.0),
          _buildBulletPoint(context, intl.appInterfaceLogoOwned),
          _buildBulletPoint(context, intl.copyingProhibited),
          const SizedBox(height: 16.0),
          Text(intl.respectingCopyright, style: titleSmall),
          const SizedBox(height: 8.0),
          _buildBulletPoint(context, intl.respectOthersRights),
          _buildBulletPoint(context, intl.handleInfringement),
          const SizedBox(height: 24.0),

          // Section 9: Service Termination
          Text(intl.serviceTermination, style: titleMedium),
          const SizedBox(height: 8.0),
          Text(intl.terminationByUser, style: titleSmall),
          const SizedBox(height: 8.0),
          _buildBulletPoint(context, intl.deleteAccount),
          _buildBulletPoint(context, intl.infoRetainedLaw),
          const SizedBox(height: 16.0),
          Text(intl.terminationByDIVIDEX, style: titleSmall),
          const SizedBox(height: 8.0),
          Text(intl.suspendTerminateAccounts, style: bodySmall),
          _buildBulletPoint(context, intl.violatingTerms),
          _buildBulletPoint(context, intl.illegalHarmfulActivities),
          _buildBulletPoint(context, intl.lawEnforcementRequests),
          _buildBulletPoint(context, intl.discontinuingService),
          const SizedBox(height: 24.0),

          // Section 10: Disclaimer
          Text(intl.disclaimer, style: titleMedium),
          const SizedBox(height: 8.0),
          Text(intl.asIsService, style: titleMedium),
          const SizedBox(height: 8.0),
          _buildBulletPoint(context, intl.serviceProvidedAsIs),
          _buildBulletPoint(context, intl.noGuaranteeOperation),
          const SizedBox(height: 16.0),
          Text(intl.limitationOfLiability, style: titleMedium),
          const SizedBox(height: 8.0),
          _buildBulletPoint(context, intl.noResponsibilityUserContent),
          _buildBulletPoint(context, intl.noGuaranteeAccuracy),
          _buildBulletPoint(context, intl.noResponsibilityIndirectDamages),
          const SizedBox(height: 24.0),

          // Section 11: Dispute Resolution
          Text(intl.disputeResolution, style: titleMedium),
          const SizedBox(height: 8.0),
          Text(intl.negotiation, style: titleSmall),
          const SizedBox(height: 8.0),
          _buildBulletPoint(context, intl.resolveThroughNegotiation),
          const SizedBox(height: 16.0),
          Text(intl.applicableLaw, style: titleSmall),
          const SizedBox(height: 8.0),
          _buildBulletPoint(context, intl.termsGovernedByLaw),
          const SizedBox(height: 16.0),
          Text(intl.courtJurisdiction, style: titleSmall),
          const SizedBox(height: 8.0),
          _buildBulletPoint(context, intl.competentCourtsResolve),
          const SizedBox(height: 24.0),

          // Section 12: Terms Updates
          Text(intl.termsUpdates, style: titleMedium),
          const SizedBox(height: 8.0),
          Text(intl.rightToModify, style: titleSmall),
          const SizedBox(height: 8.0),
          _buildBulletPoint(context, intl.updateTerms),
          _buildBulletPoint(context, intl.notificationsSent),
          const SizedBox(height: 16.0),
          Text(intl.acceptingChanges, style: titleSmall),
          const SizedBox(height: 8.0),
          _buildBulletPoint(context, intl.continuedUseMeansAgreement),
          _buildBulletPoint(context, intl.disagreeStopUse),
          const SizedBox(height: 24.0),

          // Section 13: Contact Information
          Text(
            intl.contactInformation,
            style: titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Text(intl.questionsContact, style: bodySmall),
          const SizedBox(height: 8.0),
          Text(
            intl.dIVIDEXTeam,
            style: bodySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          _buildBulletPoint(context, intl.email('support@DIVIDEXsports.com')),
          _buildBulletPoint(
            context,
            intl.address(
              '12th Floor, FPT Building, 17 Duy Tan, Cau Giay, Hanoi',
            ),
          ),
          _buildBulletPoint(context, intl.phone('024 3987 1234')),
          const SizedBox(height: 24.0),

          // Section 14: Other Terms
          Text(intl.otherTerms, style: titleMedium),
          const SizedBox(height: 8.0),
          Text(intl.severability, style: titleSmall),
          const SizedBox(height: 8.0),
          _buildBulletPoint(context, intl.invalidTerm),
          const SizedBox(height: 16.0),
          Text(intl.entireAgreement, style: titleSmall),
          const SizedBox(height: 8.0),
          _buildBulletPoint(context, intl.entireAgreementText),
          const SizedBox(height: 24.0),

          Center(
            // Centered the thank you message
            child: Text(intl.thankYouMessage, style: titleSmall),
          ),
          const SizedBox(height: 8.0),
          Center(
            child: Text(intl.lastUpdated(lastUpdatedDate), style: bodySmall),
          ), // Centered last updated date
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: Theme.of(context).textTheme.bodySmall),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}
