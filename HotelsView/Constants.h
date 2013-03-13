//
//  Constants.h
//  HotelsView
//
//

#ifndef HotelsView_Constants_h
#define HotelsView_Constants_h

#define GET_CITY_BY_KEY_WORD @"http://tkn.anywayanyday.com/GeoSuggest/Service.svc/SimpleSuggest/?term=%@&lang=%@&mode=json"
#define GET_HOTELS_BY_CITY @"http://tkn.anywayanyday.com/hotels/Hotel/List/?CityId=%@&Language=%@&Currency=%@"
#define GET_CITY_BY_REGION @"http://tkn.anywayanyday.com/GeoSuggest/Service.svc/CitiesInRectangle/?left=%.2f&top=%.2f&right=%.2f&bottom=%.2f&lang=%@&mode=json&zoom=%d"

#define APP_DOMAIN @"hotelsview.com.asdplus"

#define MINIMUM_ZOOM_ARC 0.014f
#define ANNOTATION_REGION_PAD_FACTOR 1.15f
#define MAX_DEGREES_ARC 360.0f

#define MARKER_SIZE 32.0f

#endif
