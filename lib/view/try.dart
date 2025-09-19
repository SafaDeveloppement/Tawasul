// import {
//   LocationIcon,
//   CheckIcon,
//   ArrowRightIcon,
//   ArrowdownIcon,
// } from '@assets/icons/Icons';
// import {postNewAddress} from '@services/addressServiceManager';
// import {useAuthContext} from '@Contexts/AuthContext';
// import {CustomHeader} from '@components/Header';
// import {useAddressState} from '@Contexts/AddressState';
// import Loader from '@components/Loader';
// import {useNetworkCheck} from '@Contexts/NetworkCheck';
// import {GetCities} from '@services/getCities';
// import {showToast} from '../../../../components/Toast';
// import Billing_Adress from './ShippingAddressInputs';
// import {ValidationSchema} from './utils/validationSchema';
// import RenderCities from './utils/cities';
// import {KeyboardAwareScrollView} from 'react-native-keyboard-aware-scroll-view';
// import {useTranslation} from 'react-i18next';
// import {SvgXml} from 'react-native-svg';
// import {useNavigation} from '@react-navigation/native';
// import {
//   View,
//   Text,
//   TextInput,
//   TouchableOpacity,
//   Alert,
//   I18nManager,
//   StyleSheet,
// } from 'react-native';
// import React, {useState, useLayoutEffect, useEffect} from 'react';
// import {SafeAreaView} from 'react-native-safe-area-context';
// import {Formik} from 'formik';
// const AddNewAdress = () => {
//   const navigation = useNavigation();
//   const [loading, setLoading] = useState(false);
//   const [openDeliveryCitiesList, setOpenDeliveryCitiesList] = useState(false);
//   const [openShippingCitiesList, setOpenShippingCitiesList] = useState(false);
//   const [selectedDeliveryCity, setSelectedDeliveryCity] = useState(null);
//   const [selectedShippingCity, setSelectedShippingCity] = useState(null);
//   const [cities, setCities] = useState([]);
//   const {user} = useAuthContext();
//   const {t} = useTranslation();
//   const isRTL = I18nManager.isRTL;
//   const {isConnected} = useNetworkCheck();
//   const {
//     setDefaultAddress,
//     addressLocation,
//     setAddressLocation,
//     setDefaultShippingAddress,
//   } = useAddressState();
//   const [userData, setUserData] = useState({
//     firstname: '',
//     lastname: '',
//     phonenumber: '',
//   });
//   useLayoutEffect(() => {
//     if (user) {
//       setUserData({
//         firstname: user?.firstName || '',
//         lastname: user?.lastName || '',
//         phonenumber: user?.mobile || '',
//       });
//     }
//   }, [user]);
//   useEffect(() => {
//     const GetCitiesData = async () => {
//       try {
//         const response = await GetCities();
//         if (response && response?.length > 0) {
//           setCities(response);
//         }
//       } catch (error) {
//         console.error('Error fetching cities:', error);
//       }
//     };
//     GetCitiesData();
//   }, []);
//   const handleUserDataChange = (field, value) => {
//     setUserData(prevState => ({
//       ...prevState,
//       [field]: value,
//     }));
//   };
//   const handelAddNewAdress = async (values, actions) => {
//     if (isConnected) {
//       try {
//         setLoading(true);
//         const data1 = {
//           address1: values?.address,
//           address2: values?.addtionalAddress,
//           lastName: values?.lastname,
//           firstName: values?.firstname,
//           city: values?.city,
//           postcode: values?.zipCode,
//           phone: values?.phonenumber,
//           latitude: values?.latitude,   // (اختياري) لو تحب تبعث إحداثيات
//           longitude: values?.longitude, // (اختياري)
//         };
//         const response1 = await postNewAddress(data1);
//         await setDefaultAddress(response1?.data?.response);
//         if (values.showInputs) {
//           const data2 = {
//             address1: values?.shippingAddress,
//             address2: values?.shippingAdditinalAddress,
//             lastName: values?.shippingLastName,
//             firstName: values?.shippingFirstName,
//             phone: values?.shippingPhoneNumber,
//             city: values?.shippingCity,
//             postcode: values?.shippingZipCode,
//           };
//           const response2 = await postNewAddress(data2);
//           await setDefaultShippingAddress(response2?.data?.response);
//         } else {
//           await setDefaultShippingAddress(response1?.data?.response);
//         }
//         await setAddressLocation(null);
//         actions.resetForm();
//         setLoading(false);
//         navigation.goBack();
//       } catch (error) {
//         console.error(error.message);
//         setLoading(false);
//         Alert.alert('Error', 'Failed to save address. Please try again later.');
//       }
//     } else {
//       showToast(
//         'error',
//         t('you are offline'),
//         t(
//           'To ensure the best shopping experience on Tawasul, please connect to the internet',
//         ),
//       );
//     }
//   };
//   return (
//     <SafeAreaView style={styles.container}>
//       <KeyboardAwareScrollView
//         enableOnAndroid={true}
//         enableResetScrollToCoords={false}
//         bounces={false}
//         contentContainerStyle={styles.scrollContent}
//         contentInsetAdjustmentBehavior="always"
//         overScrollMode="always">
//         <CustomHeader title={t('Add new address')} navigation={navigation} />
//         <Text style={styles.Title}>{t('ADD YOUR DETAILS')}</Text>
//         <Text style={styles.SubTitle}>{t('Delivery address')}</Text>
// 14 h 48
// <Formik
//           initialValues={{
//             firstname: userData?.firstname || '',
//             lastname: userData?.lastname || '',
//             phonenumber: userData?.phonenumber || '',
//             address: addressLocation?.street || '',
//             addtionalAddress: addressLocation?.country || '',
//             city: '',
//             zipCode: addressLocation?.postalCode || '',
//             latitude: undefined,   // (ADD) باش ما يشتكيش فورميك
//             longitude: undefined,  // (ADD)
//             showInputs: false,
//             shippingFirstName: '',
//             shippingLastName: '',
//             shippingAddress: '',
//             shippingAdditinalAddress: '',
//             shippingCity: '',
//             shippingPhoneNumber: '',
//             shippingZipCode: '',
//           }}
//           enableReinitialize={true}
//           validationSchema={ValidationSchema(t)}
//           onSubmit={handelAddNewAdress}>
//           {({
//             handleBlur,
//             handleSubmit,
//             values,
//             setFieldValue,
//             errors,
//             touched,
//           }) => (
//             <>
//               <TextInput
//                 style={[
//                   styles.defaultInput,
//                   touched.firstname && errors.firstname && styles.formError,
//                 ]}
//                 onChangeText={value => handleUserDataChange('firstname', value)}
//                 value={values.firstname}
//                 onBlur={handleBlur('firstname')}
//                 placeholder={t('First name')}
//                 placeholderTextColor="#959595"
//                 keyboardType="default"
//               />
//               {touched.firstname && errors.firstname && (
//                 <Text style={styles.formErrorTxt}>{errors.firstname}</Text>
//               )}
//               <TextInput
//                 style={[
//                   styles.defaultInput,
//                   touched.lastname && errors.lastname && styles.formError,
//                 ]}
//                 onChangeText={value => handleUserDataChange('lastname', value)}
//                 value={values.lastname}
//                 onBlur={handleBlur('lastname')}
//                 placeholder={t('Last name')}
//                 placeholderTextColor="#959595"
//                 keyboardType="default"
//               />
//               {touched.lastname && errors.lastname && (
//                 <Text style={styles.formErrorTxt}>{errors.lastname}</Text>
//               )}
//               <TextInput
//                 style={[
//                   styles.defaultInput,
//                   touched.phonenumber && errors.phonenumber && styles.formError,
//                 ]}
//                 onChangeText={value =>
//                   handleUserDataChange('phonenumber', value)
//                 }
//                 value={values?.phonenumber}
//                 placeholder={t('Phone number')}
//                 placeholderTextColor="#959595"
//                 keyboardType="number-pad"
//               />
//               {touched.phonenumber && errors.phonenumber && (
//                 <Text style={styles.formErrorTxt}>{errors.phonenumber}</Text>
//               )}
//               <Text style={styles.SubTitle}>{t('Set your localization')}</Text>
//               <View style={styles.Box_location}>
//                 <TextInput
//                   style={styles.Input_location}
//                   value={values.address}
//                   placeholder={t('Choose your location')}
//                   placeholderTextColor="black"
//                   editable={false}
//                 />
//                 {/* >>> التعديل الوحيد المهم: نبعث onSelect كيف Delivery <<< */}
//                 <TouchableOpacity
//                   onPress={() =>
//                     navigation.navigate('Location', {
//                       onSelect: ({ addressLine, city, zipCode, latitude, longitude }) => {
//                         // 1) عبّي حقول الديليفري
//                         setFieldValue('address', addressLine || '');
//                         setFieldValue('city', city || '');
//                         setFieldValue('zipCode', zipCode || '');
//                         setFieldValue('latitude', latitude);
//                         setFieldValue('longitude', longitude);
//                         // 2) نطابق المدينة مع ليست المدن
//                         const match =
//                           Array.isArray(cities) &&
//                           cities.find(
//                             c =>
//                               String(c?.name || '').toLowerCase() === String(city || '').toLowerCase() ||
//                               String(c?.label || '').toLowerCase() === String(city || '').toLowerCase()
//                           );
//                         if (match) {
//                           setSelectedDeliveryCity(match);
//                           // NOTE: لو الـAPI تحتاج ID استعمل String(match.id)
//                           setFieldValue('city', match.name || city || '');
//                         } else {
//                           setSelectedDeliveryCity({ name: city || '' });
//                         }
//                         // 3) لو billing موش نفس الديليفري → انسخ للـshipping
//                         if (values.showInputs) {
//                           setFieldValue('shippingAddress', addressLine || '');
//                           setFieldValue('shippingZipCode', zipCode || '');
//                           setFieldValue('shippingFirstName', values.firstname || '');
//                           setFieldValue('shippingLastName', values.lastname || '');
//                           setFieldValue('shippingPhoneNumber', values.phonenumber || '');
//                           if (match) {
//                             setSelectedShippingCity(match);
//                             setFieldValue('shippingCity', match.name); // أو String(match.id)
//                           } else {
//                             setSelectedShippingCity({ name: city || '' });
//                             setFieldValue('shippingCity', city || '');
//                           }
//                         }
//                       },
//                     })
//                   }>
//                   <SvgXml xml={LocationIcon} width={20} height={20} />
//                 </TouchableOpacity>
//               </View>
//               <Text style={styles.SubTitle}>
//                 {t('Or set all your information below')}
//               </Text>
//               <TextInput
//                 style={[
//                   styles.defaultInput,
//                   touched.address && errors.address && styles.formError,
//                 ]}
//                 onChangeText={value => setFieldValue('address', value)}
//                 value={values.address}
//                 onBlur={handleBlur('address')}
//                 placeholder={t('Address')}
//                 placeholderTextColor="#959595"
//                 keyboardType="default"
//               />
//               {touched.address && errors.address && (
//                 <Text style={styles.formErrorTxt}>{errors.address}</Text>
//               )}
//               <View style={styles.Box_location}>
//                 <TextInput
//                   style={styles.Input_location}
//                   onChangeText={value =>
//                     setFieldValue('addtionalAddress', value)
//                   }
//                   value={values.addtionalAddress}
//                   placeholder={t('Additional address')}
//                   placeholderTextColor="#959595"
//                 />
//                 <Text style={styles.OptionalText}>{t('Optional')}</Text>
//               </View>
//               <View style={styles.mini_box_container}>
//                 <TouchableOpacity
//                   style={[
//                     styles.miniInputContainerWithOptionalTxt,
//                     touched.city && errors.city && styles.formError,
//                   ]}
//                   onPress={() =>
//                     setOpenDeliveryCitiesList(!openDeliveryCitiesList)
//                   }>
//                   <Text style={styles.miniInputWithOptionalTxt}>
//                     {selectedDeliveryCity
//                       ? selectedDeliveryCity?.name
//                       : (values.city || t('Select City'))}
//                   </Text>
//                   <SvgXml xml={ArrowdownIcon} />
//                 </TouchableOpacity>
//                 {openDeliveryCitiesList && (
//                   <RenderCities
//                     cities={cities}
//                     openDeliveryCitiesList={openDeliveryCitiesList}
//                     setOpenDeliveryCitiesList={setOpenDeliveryCitiesList}
//                     selectedDeliveryCity={selectedDeliveryCity}
//                     setSelectedDeliveryCity={(c) => {
//                       setSelectedDeliveryCity(c);
//                       // NOTE: لو API تحتاج ID بدّل name بـ String(c.id)
//                       setFieldValue('city', c?.name || '');
//                     }}
//                     setFieldValue={setFieldValue}
//                   />
//                 )}
//                 <View style={styles.miniInputContainerWithOptionalTxt}>
//                   <TextInput
//                     style={styles.miniInputWithOptionalTxt}
//                     onChangeText={value => setFieldValue('zipCode', value)}
//                     value={values.zipCode}
//                     placeholder={t('Zip code')}
//                     keyboardType="number-pad"
//                     placeholderTextColor="#959595"
//                     maxLength={6}
//                   />
//                   <Text style={styles.OptionalText}>{t('Optional')}</Text>
//                 </View>
//               </View>
//               {touched.city && errors.city && (
//                 <Text style={styles.formErrorTxt}>{errors.city}</Text>
//               )}
//               <View style={styles.billing}>
//                 <TouchableOpacity
//                   onPress={() =>
//                     setFieldValue('showInputs', !values.showInputs)
//                   }
//                   style={styles.checkbox}>
//                   {!values.showInputs ? (
//                     <SvgXml xml={CheckIcon} width={28} height={28} />
//                   ) : null}
//                 </TouchableOpacity>
//                 <View>
//                   <Text style={styles.billing_title}>
//                     {t('MY BILLING ADDRESS')}
//                   </Text>
//                   <Text style={styles.billing_subtitle}>
//                     {t('is the same as my delivery address')}
//                   </Text>
//                 </View>
//               </View>
//               {values.showInputs && (
//                 <Billing_Adress
//                   handleBlur={handleBlur}
//                   touched={touched}
//                   values={values}
//                   setFieldValue={setFieldValue}
//                   errors={errors}
//                   t={t}
//                   styles={styles}
//                   cities={cities}
//                   openShippingCitiesList={openShippingCitiesList}
//                   setOpenShippingCitiesList={setOpenShippingCitiesList}
//                   selectedShippingCity={selectedShippingCity}
//                   setSelectedShippingCity={(c) => {
//                     setSelectedShippingCity(c);
//                     // NOTE: لو API تحتاج ID بدّل name بـ String(c.id)
//                     setFieldValue('shippingCity', c?.name || '');
//                   }}
//                 />
//               )}
//               <TouchableOpacity style={styles.Button} onPress={handleSubmit}>
//                 <Text style={styles.ButtonText}>{t('SAVE AND CONTINUE')}</Text>
//                 {/* <View
//                   style={[
//                     styles.icon,
//                     isRTL && {transform: [{rotateY: '180deg'}]},
//                   ]}>
//                   <SvgXml xml={ArrowRightIcon} width={15} height={15} />
//                 </View> */}
//               </TouchableOpacity>
//             </>
//           )}
//         </Formik>
//       </KeyboardAwareScrollView>
//       <Loader loading={loading} />
//     </SafeAreaView>
//   );
// q445vd4fdvfqfdqfd};
// 14 h 49
// import {
//   LocationIcon,
//   CheckIcon,
//   ArrowRightIcon,
//   ArrowdownIcon,
// } from '@assets/icons/Icons';
// import {postNewAddress} from '@services/addressServiceManager';
// import {useAuthContext} from '@Contexts/AuthContext';
// import {CustomHeader} from '@components/Header';
// import {useAddressState} from '@Contexts/AddressState';
// import Loader from '@components/Loader';
// import {useNetworkCheck} from '@Contexts/NetworkCheck';
// import {GetCities} from '@services/getCities';
// import {showToast} from '../../../../components/Toast';
// import Billing_Adress from './ShippingAddressInputs';
// import {ValidationSchema} from './utils/validationSchema';
// import RenderCities from './utils/cities';
// import {KeyboardAwareScrollView} from 'react-native-keyboard-aware-scroll-view';
// import {useTranslation} from 'react-i18next';
// import {SvgXml} from 'react-native-svg';
// import {useNavigation} from '@react-navigation/native';
// import {
//   View,
//   Text,
//   TextInput,
//   TouchableOpacity,
//   Alert,
//   I18nManager,
//   StyleSheet,
// } from 'react-native';
// import React, {useState, useLayoutEffect, useEffect} from 'react';
// import {SafeAreaView} from 'react-native-safe-area-context';
// import {Formik} from 'formik';
// const AddNewAdress = () => {
//   const navigation = useNavigation();
//   const [loading, setLoading] = useState(false);
//   const [openDeliveryCitiesList, setOpenDeliveryCitiesList] = useState(false);
//   const [openShippingCitiesList, setOpenShippingCitiesList] = useState(false);
//   const [selectedDeliveryCity, setSelectedDeliveryCity] = useState(null);
//   const [selectedShippingCity, setSelectedShippingCity] = useState(null);
//   const [cities, setCities] = useState([]);
//   const {user} = useAuthContext();
//   const {t} = useTranslation();
//   const isRTL = I18nManager.isRTL;
//   const {isConnected} = useNetworkCheck();
//   const {
//     setDefaultAddress,
//     addressLocation,
//     setAddressLocation,
//     setDefaultShippingAddress,
//   } = useAddressState();
//   const [userData, setUserData] = useState({
//     firstname: '',
//     lastname: '',
//     phonenumber: '',
//   });
//   useLayoutEffect(() => {
//     if (user) {
//       setUserData({
//         firstname: user?.firstName || '',
//         lastname: user?.lastName || '',
//         phonenumber: user?.mobile || '',
//       });
//     }
//   }, [user]);
//   useEffect(() => {
//     const GetCitiesData = async () => {
//       try {
//         const response = await GetCities();
//         if (response && response?.length > 0) {
//           setCities(response);
//         }
//       } catch (error) {
//         console.error('Error fetching cities:', error);
//       }
//     };
//     GetCitiesData();
//   }, []);
//   const handleUserDataChange = (field, value) => {
//     setUserData(prevState => ({
//       ...prevState,
//       [field]: value,
//     }));
//   };
//   const handelAddNewAdress = async (values, actions) => {
//     if (isConnected) {
//       try {
//         setLoading(true);
//         const data1 = {
//           address1: values?.address,
//           address2: values?.addtionalAddress,
//           lastName: values?.lastname,
//           firstName: values?.firstname,
//           city: values?.city,
//           postcode: values?.zipCode,
//           phone: values?.phonenumber,
//           latitude: values?.latitude,   // (اختياري) لو تحب تبعث إحداثيات
//           longitude: values?.longitude, // (اختياري)
//         };
// 14 h 49
// const response1 = await postNewAddress(data1);
//         await setDefaultAddress(response1?.data?.response);
//         if (values.showInputs) {
//           const data2 = {
//             address1: values?.shippingAddress,
//             address2: values?.shippingAdditinalAddress,
//             lastName: values?.shippingLastName,
//             firstName: values?.shippingFirstName,
//             phone: values?.shippingPhoneNumber,
//             city: values?.shippingCity,
//             postcode: values?.shippingZipCode,
//           };
//           const response2 = await postNewAddress(data2);
//           await setDefaultShippingAddress(response2?.data?.response);
//         } else {
//           await setDefaultShippingAddress(response1?.data?.response);
//         }
//         await setAddressLocation(null);
//         actions.resetForm();
//         setLoading(false);
//         navigation.goBack();
//       } catch (error) {
//         console.error(error.message);
//         setLoading(false);
//         Alert.alert('Error', 'Failed to save address. Please try again later.');
//       }
//     } else {
//       showToast(
//         'error',
//         t('you are offline'),
//         t(
//           'To ensure the best shopping experience on Tawasul, please connect to the internet',
//         ),
//       );
//     }
//   };
//   return (
//     <SafeAreaView style={styles.container}>
//       <KeyboardAwareScrollView
//         enableOnAndroid={true}
//         enableResetScrollToCoords={false}
//         bounces={false}
//         contentContainerStyle={styles.scrollContent}
//         contentInsetAdjustmentBehavior="always"
//         overScrollMode="always">
//         <CustomHeader title={t('Add new address')} navigation={navigation} />
//         <Text style={styles.Title}>{t('ADD YOUR DETAILS')}</Text>
//         <Text style={styles.SubTitle}>{t('Delivery address')}</Text>
//         <Formik
//           initialValues={{
//             firstname: userData?.firstname || '',
//             lastname: userData?.lastname || '',
//             phonenumber: userData?.phonenumber || '',
//             address: addressLocation?.street || '',
//             addtionalAddress: addressLocation?.country || '',
//             city: '',
//             zipCode: addressLocation?.postalCode || '',
//             latitude: undefined,   // (ADD) باش ما يشتكيش فورميك
//             longitude: undefined,  // (ADD)
//             showInputs: false,
//             shippingFirstName: '',
//             shippingLastName: '',
//             shippingAddress: '',
//             shippingAdditinalAddress: '',
//             shippingCity: '',
//             shippingPhoneNumber: '',
//             shippingZipCode: '',
//           }}
//           enableReinitialize={true}
//           validationSchema={ValidationSchema(t)}
//           onSubmit={handelAddNewAdress}>
//           {({
//             handleBlur,
//             handleSubmit,
//             values,
//             setFieldValue,
//             errors,
//             touched,
//           }) => (
//             <>
//               <TextInput
//                 style={[
//                   styles.defaultInput,
//                   touched.firstname && errors.firstname && styles.formError,
//                 ]}
//                 onChangeText={value => handleUserDataChange('firstname', value)}
//                 value={values.firstname}
//                 onBlur={handleBlur('firstname')}
//                 placeholder={t('First name')}
//                 placeholderTextColor="#959595"
//                 keyboardType="default"
//               />
//               {touched.firstname && errors.firstname && (
//                 <Text style={styles.formErrorTxt}>{errors.firstname}</Text>
//               )}
//               <TextInput
//                 style={[
//                   styles.defaultInput,
//                   touched.lastname && errors.lastname && styles.formError,
//                 ]}
//                 onChangeText={value => handleUserDataChange('lastname', value)}
//                 value={values.lastname}
//                 onBlur={handleBlur('lastname')}
//                 placeholder={t('Last name')}
//                 placeholderTextColor="#959595"
//                 keyboardType="default"
//               />
//               {touched.lastname && errors.lastname && (
//                 <Text style={styles.formErrorTxt}>{errors.lastname}</Text>
//               )}
//               <TextInput
//                 style={[
//                   styles.defaultInput,
//                   touched.phonenumber && errors.phonenumber && styles.formError,
//                 ]}
//                 onChangeText={value =>
//                   handleUserDataChange('phonenumber', value)
//                 }
//                 value={values?.phonenumber}
//                 placeholder={t('Phone number')}
//                 placeholderTextColor="#959595"
//                 keyboardType="number-pad"
//               />
//               {touched.phonenumber && errors.phonenumber && (
//                 <Text style={styles.formErrorTxt}>{errors.phonenumber}</Text>
//               )}
//               <Text style={styles.SubTitle}>{t('Set your localization')}</Text>
//               <View style={styles.Box_location}>
//                 <TextInput
//                   style={styles.Input_location}
//                   value={values.address}
//                   placeholder={t('Choose your location')}
//                   placeholderTextColor="black"
//                   editable={false}
//                 />
// 14 h 49
// <TouchableOpacity
//                   onPress={() =>
//                     navigation.navigate('Location', {
//                       onSelect: ({ addressLine, city, zipCode, latitude, longitude }) => {
//                         // 1) عبّي حقول الديليفري
//                         setFieldValue('address', addressLine || '');
//                         setFieldValue('city', city || '');
//                         setFieldValue('zipCode', zipCode || '');
//                         setFieldValue('latitude', latitude);
//                         setFieldValue('longitude', longitude);
//                         // 2) نطابق المدينة مع ليست المدن
//                         const match =
//                           Array.isArray(cities) &&
//                           cities.find(
//                             c =>
//                               String(c?.name || '').toLowerCase() === String(city || '').toLowerCase() ||
//                               String(c?.label || '').toLowerCase() === String(city || '').toLowerCase()
//                           );
//                         if (match) {
//                           setSelectedDeliveryCity(match);
//                           // NOTE: لو الـAPI تحتاج ID استعمل String(match.id)
//                           setFieldValue('city', match.name || city || '');
//                         } else {
//                           setSelectedDeliveryCity({ name: city || '' });
//                         }
//                         // 3) لو billing موش نفس الديليفري → انسخ للـshipping
//                         if (values.showInputs) {
//                           setFieldValue('shippingAddress', addressLine || '');
//                           setFieldValue('shippingZipCode', zipCode || '');
//                           setFieldValue('shippingFirstName', values.firstname || '');
//                           setFieldValue('shippingLastName', values.lastname || '');
//                           setFieldValue('shippingPhoneNumber', values.phonenumber || '');
//                           if (match) {
//                             setSelectedShippingCity(match);
//                             setFieldValue('shippingCity', match.name); // أو String(match.id)
//                           } else {
//                             setSelectedShippingCity({ name: city || '' });
//                             setFieldValue('shippingCity', city || '');
//                           }
//                         }
//                       },
//                     })
//                   }>
//                   <SvgXml xml={LocationIcon} width={20} height={20} />
//                 </TouchableOpacity>
//               </View>
//               <Text style={styles.SubTitle}>
//                 {t('Or set all your information below')}
//               </Text>
//               <TextInput
//                 style={[
//                   styles.defaultInput,
//                   touched.address && errors.address && styles.formError,
//                 ]}
//                 onChangeText={value => setFieldValue('address', value)}
//                 value={values.address}
//                 onBlur={handleBlur('address')}
//                 placeholder={t('Address')}
//                 placeholderTextColor="#959595"
//                 keyboardType="default"
//               />
//               {touched.address && errors.address && (
//                 <Text style={styles.formErrorTxt}>{errors.address}</Text>
//               )}
//               <View style={styles.Box_location}>
//                 <TextInput
//                   style={styles.Input_location}
//                   onChangeText={value =>
//                     setFieldValue('addtionalAddress', value)
//                   }
//                   value={values.addtionalAddress}
//                   placeholder={t('Additional address')}
//                   placeholderTextColor="#959595"
//                 />
//                 <Text style={styles.OptionalText}>{t('Optional')}</Text>
//               </View>
//               <View style={styles.mini_box_container}>
//                 <TouchableOpacity
//                   style={[
//                     styles.miniInputContainerWithOptionalTxt,
//                     touched.city && errors.city && styles.formError,
//                   ]}
//                   onPress={() =>
//                     setOpenDeliveryCitiesList(!openDeliveryCitiesList)
//                   }>
//                   <Text style={styles.miniInputWithOptionalTxt}>
//                     {selectedDeliveryCity
//                       ? selectedDeliveryCity?.name
//                       : (values.city || t('Select City'))}
//                   </Text>
//                   <SvgXml xml={ArrowdownIcon} />
//                 </TouchableOpacity>
//                 {openDeliveryCitiesList && (
//                   <RenderCities
//                     cities={cities}
//                     openDeliveryCitiesList={openDeliveryCitiesList}
//                     setOpenDeliveryCitiesList={setOpenDeliveryCitiesList}
//                     selectedDeliveryCity={selectedDeliveryCity}
//                     setSelectedDeliveryCity={(c) => {
//                       setSelectedDeliveryCity(c);
//                       // NOTE: لو API تحتاج ID بدّل name بـ String(c.id)
//                       setFieldValue('city', c?.name || '');
//                     }}
//                     setFieldValue={setFieldValue}
//                   />
//                 )}
//                 <View style={styles.miniInputContainerWithOptionalTxt}>
//                   <TextInput
//                     style={styles.miniInputWithOptionalTxt}
//                     onChangeText={value => setFieldValue('zipCode', value)}
//                     value={values.zipCode}
//                     placeholder={t('Zip code')}
//                     keyboardType="number-pad"
//                     placeholderTextColor="#959595"
//                     maxLength={6}
//                   />
//                   <Text style={styles.OptionalText}>{t('Optional')}</Text>
//                 </View>
//               </View>
//               {touched.city && errors.city && (
//                 <Text style={styles.formErrorTxt}>{errors.city}</Text>
//               )}
//               <View style={styles.billing}>
//                 <TouchableOpacity
//                   onPress={() =>
//                     setFieldValue('showInputs', !values.showInputs)
//                   }
//                   style={styles.checkbox}>
//                   {!values.showInputs ? (
//                     <SvgXml xml={CheckIcon} width={28} height={28} />
//                   ) : null}
//                 </TouchableOpacity>
//                 <View>
//                   <Text style={styles.billing_title}>
//                     {t('MY BILLING ADDRESS')}
//                   </Text>
//                   <Text style={styles.billing_subtitle}>
//                     {t('is the same as my delivery address')}
//                   </Text>
//                 </View>
//               </View>
//               {values.showInputs && (
//                 <Billing_Adress
//                   handleBlur={handleBlur}
//                   touched={touched}
//                   values={values}
//                   setFieldValue={setFieldValue}
//                   errors={errors}
//                   t={t}
//                   styles={styles}
//                   cities={cities}
//                   openShippingCitiesList={openShippingCitiesList}
//                   setOpenShippingCitiesList={setOpenShippingCitiesList}
//                   selectedShippingCity={selectedShippingCity}
//                   setSelectedShippingCity={(c) => {
//                     setSelectedShippingCity(c);
//                     // NOTE: لو API تحتاج ID بدّل name بـ String(c.id)
//                     setFieldValue('shippingCity', c?.name || '');
//                   }}
//                 />
//               )}
//               <TouchableOpacity style={styles.Button} onPress={handleSubmit}>
//                 <Text style={styles.ButtonText}>{t('SAVE AND CONTINUE')}</Text>
//                 {/* <View
//                   style={[
//                     styles.icon,
//                     isRTL && {transform: [{rotateY: '180deg'}]},
//                   ]}>
//                   <SvgXml xml={ArrowRightIcon} width={15} height={15} />
//                 </View> */}
//               </TouchableOpacity>
//             </>
//           )}
//         </Formik>
//       </KeyboardAwareScrollView>
//       <Loader loading={loading} />
//     </SafeAreaView>
//   );
// };
// const styles = StyleSheet.create({
//   container: {
//     flex: 1,
//     backgroundColor: '#F5F6F8',
//   },
//   scrollContent: {
//     flexGrow: 1,
//     paddingBottom: 40,
//   },
//   defaultInput: {
//     width: '90%',
//     height: 50,
//     backgroundColor: 'white',
//     marginVertical: 10,
//     paddingHorizontal: 20,
//     borderRadius: 15,
//     color: 'black',
//     fontSize: 12,
//     opacity: 1,
//     letterSpacing: 0,
//     fontFamily: 'NeusaNextPro-Medium',
//     marginHorizontal: '5%',
//     elevation: 1,
//   },
//   Title: {
//     fontSize: 16,
//     fontFamily: 'NeusaNextPro-Bold',
//     color: 'black',
//     marginHorizontal: '5%',
//   },
//   SubTitle: {
//     fontSize: 14,
//     color: '#515C6F',
//     fontFamily: 'NeusaNextPro-Regular',
//     marginTop: 19,
//     lineHeight: 21,
//     marginHorizontal: '5%',
//   },
//   Box_location: {
//     width: '90%',
//     height: 50,
//     backgroundColor: 'white',
//     marginVertical: 10,
//     borderRadius: 15,
//     paddingHorizontal: 20,
//     flexDirection: 'row',
//     justifyContent: 'space-between',
//     alignItems: 'center',
//     marginHorizontal: '5%',
//     elevation: 1,
//   },
//   Input_location: {
//     color: 'black',
//     width: '85%',
//     height: '100%',
//     fontSize: 12,
//     opacity: 1,
//     letterSpacing: 0,
//     fontFamily: 'NeusaNextPro-Medium',
//   },
//   OptionalText: {
//     fontSize: 10,
//     color: '#949494',
//     fontFamily: 'NeusaNextPro-Medium',
//     opacity: 1,
//     letterSpacing: 0,
//   },
//   mini_box_container: {
//     flexDirection: 'row',
//     justifyContent: 'space-between',
//     alignItems: 'center',
//     width: '90%',
//     marginHorizontal: '5%',
//     marginVertical: 10,
//   },
//   miniInputContainerWithOptionalTxt: {
//     width: '48%',
//     height: 50,
//     flexDirection: 'row',
//     justifyContent: 'space-between',
//     alignItems: 'center',
//     paddingHorizontal: 20,
//     backgroundColor: 'white',
//     borderRadius: 15,
//     elevation: 1,
//   },
//   miniInputWithOptionalTxt: {
//     color: 'black',
//     fontSize: 12,
//     fontFamily: 'NeusaNextPro-Medium',
//     opacity: 1,
//     letterSpacing: 0,
//   },
//   billing: {
//     backgroundColor: 'white',
//     width: '90%',
//     marginHorizontal: '5%',
//     height: 80,
//     borderRadius: 20,
//     flexDirection: 'row',
//     paddingHorizontal: '7%',
//     alignItems: 'center',
//     marginVertical: 15,
//     elevation: 1,
//   },
//   billing_title: {
//     color: 'black',
//     fontSize: 14,
//     fontFamily: 'NeusaNextPro-Medium',
//     opacity: 1,
//     letterSpacing: 0,
//   },
//   billing_subtitle: {
//     color: '#515C6F',
//     fontSize: 13,
//     fontFamily: 'NeusaNextPro-Medium',
//     opacity: 1,
//   },
//   checkbox: {
//     width: 26,
//     height: 26,
//     marginRight: 15,
//     borderRadius: 7,
//     borderWidth: 1,
//     borderColor: '#515C6F',
//     justifyContent: 'center',
//     alignItems: 'center',
//   },
//   Button: {
//     width: '90%',
//   height: 40,
//   marginHorizontal: '5%',
//   borderRadius: 10,
//   backgroundColor: '#0984E3',
//   alignItems: 'center',
//   justifyContent: 'center',
//   shadowColor: 'transparent',
//   elevation: 0,
//   },
//   ButtonText: {
//     color: 'white',
//     fontSize: 12,
//     fontFamily: 'NeusaNextPro-Bold',
//     opacity: 1,
//     letterSpacing: 0.72,
//     textTransform: 'uppercase',
//   },
//   icon: {
//     height: 30,
//     width: 30,
//     backgroundColor: 'white',
//     borderRadius: 20,
//     justifyContent: 'center',
//     alignItems: 'center',
//     position: 'absolute',
//     right: 10,
//   },
//   formError: {
//     borderColor: 'red',
//     borderWidth: 1,
//   },
//   formErrorTxt: {
//     fontFamily: 'NeusaNextPro-Regular',
//     fontSize: 12,
//     color: 'red',
//     marginHorizontal: '10%',
//   },
// });
// export default AddNewAdress;




















