# Introduction #

KivaWrap is the primary class needed to communicate with the KivaAPI.

## public properties ##
```
appID : String           // application ID to send when making calls
returnType : String      // format in which to request data from the KivaAPI
dispatchMode : String    // decides what events to dispatch when a call is made
```

## static constants ##
```
// Use these TYPE_ constants for setting the value of "returnType"
TYPE_XML:String
TYPE_JSON:String
TYPE_HTML:String

// Use these DISPATCH_ constants for setting the value of "dispatchMode"
DISPATCH_UNIQUE:String    // dispatch KivaWrapEvent of types associated to each method
DISPATCH_COMPLETE:String  // dispatch KivaWrapEvent of type "COMPLETE" for all methods
DISPATCH_BOTH:String      // dispatch both UNIQUE and COMPLETE types for all methods

// Use these SORT_ constancts whenever a sort parameter is available for a method
// *note* not all methods except every sort type.
SORT_NEW:String
SORT_OLD:String
SORT_POPULARITY:String
SORT_LOAN_AMOUNT:String
SORT_EXPIRATION:String
SORT_AMOUNT_REM:String
SORT_REPAYMENT_T:String
SORT_RECOMMENDATION_C:String 
SORT_COMMENT_C:String 

// these are other few parameters that can be used in various methods that accept them
MEDIA_ANY:String 
MEDIA_VIDEO:String 
MEDIA_IMAGE:String 
STATUS_FUNDRAISING:String 
STATUS_FUNDED:String 
STATUS_IN_REPAYMENT:String 
STATUS_PAID:String 
STATUS_DEFAULTED:String

// Use these IMG_ size constants for the getImageURL method
IMG_80x80:String
IMG_200x200:String
IMG_325x250:String
IMG_450x360:String
IMG_FULLSIZE:String

// for reference, internal, and just-in-case-you-need-it purposes
IMG_URL_TMPL:String
API_BASE_URL:String
```

## Public Methods ##
`static function getImageURL ( imageID:Number, size:String = KivaWrap.IMG_200x200 ):String`

Add your content here.  Format your content with:
  * Text in **bold** or _italic_
  * Headings, paragraphs, and lists
  * Automatic links to other wiki pages