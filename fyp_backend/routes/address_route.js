const router =require('express').Router();
const {verifyAndAuthorization}=require('../middlewares/varifyTokens');
const addressController = require('../controllers/address_controller');


router.post('/',verifyAndAuthorization,addressController.createAddress);
router.delete('/:id',verifyAndAuthorization,addressController.deleteAddress);
router.get('/',verifyAndAuthorization,addressController.getUserAddress);
router.get('/default',verifyAndAuthorization,addressController.getDefaultAddress);
router.put('/:id',verifyAndAuthorization,addressController.updateAddress);
router.post('/default/:id',verifyAndAuthorization,addressController.updateAddress);

module.exports =router




// {
//     "place_id": 243933658,
//     "licence": "Data © OpenStreetMap contributors, ODbL 1.0. http://osm.org/copyright",
//     "osm_type": "way",
//     "osm_id": 16112062,
//     "lat": "31.5203624589535",
//     "lon": "74.35872240381507",
//     "class": "highway",
//     "type": "secondary",
//     "place_rank": 26,
//     "importance": 0.10000999999999993,
//     "addresstype": "road",
//     "name": "Gurumangat Road",
//     "display_name": "Gurumangat Road, Nabipura, گلبرگ, لاہور, Lahore Cantonment Tehsil, لاہور ڈویژن, پنجاب, 54660, پاکستان",
//     "address": {
//         "road": "Gurumangat Road",
//         "neighbourhood": "Nabipura",
//         "suburb": "گلبرگ",
//         "city": "لاہور",
//         "subdistrict": "Lahore Cantonment Tehsil",
//         "historical_division": "لاہور ڈویژن",
//         "state": "پنجاب",
//         "ISO3166-2-lvl3": "PK-PB",
//         "postcode": "54660",
//         "country": "پاکستان",
//         "country_code": "pk"
//     },
//     "boundingbox": [
//         "31.5195932",
//         "31.5233236",
//         "74.3550138",
//         "74.3588556"
//     ]
// }