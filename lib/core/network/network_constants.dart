// const String baseUrl='https://test.menaplatforms.com/api/v1';
const String baseUrl = 'https://menaaii.com/api/v1';

///zego appId
int zegoAppId = 1810631269;
String zegoAppSign = '3439f7f8cb0ac4a7083534e3bb826ef1ccacfe889941bd2943475f30e1e32e09';

///config
const String configEnd = '/start';
const String countersEnd = '/users/counters';

///Users
const String loginEnd = '/users/login';
const String registerEnd = '/users/register';
const String followUserEnd = '/users/follow';
const String unfollowUserEnd = '/users/unfollow';
const String getProviderTypesEnd = '/provider-types';
const String requestResetPassOtpEnd = '/users/forget-password';
const String submitResetPassEnd = '/users/reset-password';
const String verifyCodeEnd = '/users/register/verify-code';

/// user info
const String userInfoEnd = '/users/info';

/// platform categories
const String platformCategoriesEnd = '/platforms/categories';

/// required additional data
const String requiredFieldsDataEnd = '/platforms/fields';
const String submitRequiredFieldsDataEnd = '/users/update-platform-fields';

/// chat
const String sendMsgEnd = '/chat/send';
const String deleteChatEnd = '/chat/delete';
const String markAsReadChatEnd = '/chat/mark-as-read';
const String reportToMENAChatEnd = '/chat/report-to-mena';
const String blockUserChatEnd = '/chat/block-user-chat';
const String clearChatEnd = '/chat/clear-chat';
const String getChatMessagesEnd = '/chat/messages';
const String getChatUsersEnd = '/users/all';
const String getMyMessagesEnd = '/chat/get';
const String getOnlineUsersEnd = '/chat/online';

///appointments
const String getInsuranceProvidersListEnd = '/appointments/insurance_providers';
const String searchAppointmentsProfessionalFacilitiesEnd = '/appointments/search';
const String getAppointmentsSlotsEnd = '/appointments/slots';
const String saveAppointmentsEnd = '/appointments/save';
const String getClientAppointmentsEnd = '/appointments/client-appointments';
const String getMySLotsEnd = '/appointments/my-slots';
const String getAppHistoryEnd = '/appointments/history';
const String deleteSlotEnd = '/appointments/slots/delete';
const String updateClientAppointmentEnd = '/appointments/client-appointments/update';
const String getProfProvidersListEnd = '/appointments/slots/prof-fac';
const String saveSlotEnd = '/appointments/slots/create';
const String updateSlotEnd = '/appointments/slots/update';

///e-services
const String getEServicesInfoEnd = '/e-services/info';

///blogs
const String getBlogsInfoEnd = '/blogs/info';
const String getBlogsItemsEnd = '/blogs/all';
const String getBlogDetailsEnd = '/blogs/details';

/// feeds
const String getFeedsEnd = '/feeds/get-all';
const String getFeedsVideosEnd = '/feeds/get-all/videos';
const String getCommentsEnd = '/feeds/comment';
const String deleteFeedEnd = '/feeds/delete';
const String deleteCommentEnd = '/feeds/comment/delete';
const String likeCommentEnd = '/feeds/comment/like';
const String updateFeedEnd = '/feeds/update';
const String reportFeedEnd = '/feeds/report';
const String likeFeedEnd = '/feeds/like';
const String addNewFeedEnd = '/feeds/post';

/// category details and provider
const String categoryDetailsEnd = '/providers/category-details';

///provider profile control
///add
const String addUserProfilePicEnd = '/providers/personal_picture/edit';
const String addCmeEnd = '/providers/cme';
const String addProviderEducationEnd = '/providers/educations';
const String addProviderExperienceEnd = '/providers/experiences';
const String addProviderPublicationsEnd = '/providers/publications';
const String addProviderCertificationsEnd = '/providers/certificates';
const String addProviderMembershipEnd =
    '/providers/memberships'; // const String updateProviderEducationEnd = '/providers/educations/edit';
const String addProviderRewardEnd =
    '/providers/awards'; // const String updateProviderEducationEnd = '/providers/educations/edit';
///update
const String updateProviderEducationEnd = '/providers/educations/edit';
const String updateProviderExperienceEnd = '/providers/experiences/edit';
const String updateProviderPublicationsEnd = '/providers/publications/edit';
const String updateProviderCertificationEnd = '/providers/certificates/edit';
const String updateProviderMembershipEnd = '/providers/memberships/edit';
const String updateProviderRewardEnd = '/providers/awards/edit';
const String updateAboutEnd = '/providers/about/edit';

///remove
const String deleteProviderEducationEnd = '/providers/educations/delete';
const String deleteProviderCertificateEnd = '/providers/certificates/delete';
const String deleteProviderMembershipEnd = '/providers/memberships/delete';
const String deleteProviderRewardEnd = '/providers/awards/delete';
const String deleteProviderExperienceEnd = '/providers/experiences/delete';
const String deleteProviderPublicationEnd = '/providers/publications/delete';

///
/// provider details
const String providerDetailsEnd = '/providers/details';
const String providerProfessionalsEnd = '/professional/get-all';

///
const String getPlansEnd = '/platforms/plans';

/// home section
const String homeSectionEnd = '/home-section';

/// live
const String goLiveEnd = '/live/go-live';
const String setLiveStartEnd = '/live/set-live';
const String setLiveEndedEnd = '/live/set-not-live';
const String getLivesEnd = '/live/get-lives';
const String getCategoriesEnd = '/live/get-categories';

///
const String getLivesNowEnd = '/live/live-categories';
const String getUpcomingLiveCategoriesEnd = '/live/upcoming-categories';

///Meetings
const String getMeetingsConfigEnd = '/meeting/start';
const String getMyMeetingsEnd = '/meeting/my';
const String deleteMeetingEnd = '/meeting/delete';
const String saveMeetingEnd = '/meeting/save';
const String editMeetingEnd = '/meeting/edit';

///
