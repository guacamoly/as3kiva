as3Kiva is a simple API wrapper in Actionscript 3 for accessing data from the Kiva API.  <br />The wrapper class provides easy methods to get the data from the Kiva API in the desired format and converts the result to its relative AS3 object<br />
html=>String, json=>Object, xml=>XML


### Requirements ###
**as3corelib** : this opensource as3 library is used to deserialize .json strings returned by the KivaAPI to AS3 objects.
<br />
**note** : for now please make sure you always pass in the "page" parameter for all methods in the wrapper.

### Description ###
The KivaWrap class is the primary API wrapper class that contains all methods for getting data from the Kiva API.  When a request to the api is made and a valid result is returned, the class dispatches an event of the type associated with the particular method called.  Refer to the table below for methods and their associated even types.

#### setup ####
```
import com.humsara.kiva.KivaWrap;
import com.humsara.kiva.KivaWrapEvent;

// instantiate KivaWrap
var kivaAPI:KivaWrap = new KivaWrap();

// set returnType:String - possible values KivaWrap.TYPE_XML, KivaWrap.TYPE_JSON, KivaWrap.TYPE_HTML
//   returnType is defaulted to TYPE_JSON
kivaAPI.returnType = KivaWrap.TYPE_JSON;

// set dispatchMode:String - possible values 
//   KivaWrap.DISPATCH_UNIQUE : *default* each method dispatches a unique KivaWrapEvent type (look at method table below) 
//   KivaWrap.DISPATCH_COMPLETE : all methods dispatch KivaWrapEvent.COMPLETE type
//   KivaWrap.DISPATCH_BOTH : both unique and complete event types are dispatched
kivaAPI.dispatchMode = KivaWrap.DISPATCH_BOTH;

// set formatResult:Boolean  - default true
//   The kivaAPI returns data as a serialized string.  It is up to the application to
//   parse the string into a usable format.  KivaWrap.as by default will convert json
//   and xml serialized strings to AS3 Object() and AS3 XML() types respectively. 
//   Should you desire to not do so and simply access the string returned by the kivaapi
//   set this variable to false; 
//   Otherwise you can leave this statement out, since the default value is true;
kivaAPI.formatResult = true;

// set appID:String  - the KivaAPI requests as good practice to send in an application
//   id whenever a call is made.  By default the appID is set to "com.humsara.as3.kivaAPIwrap"
kivaAPI.appID = "com.mydomain.myappname";

```

#### lets make a call to get a list of the newest loans on kiva : getNewestLoans ####
```
// create listener for getNewestLoans method
kivaAPI.addEventListener ( KivaWrapEvent.LOAN_NEWEST, onGetLoans );
// make the call to the api
kivaAPI.getNewestLoans ();

// create handler function for when loan data is returned
function onGetLoans ( evt:KivaWrapEvent ):void {
    // the requested data is in the property of name "data"
    var jsonData:Object = evt.data;  // if returnType = KivaWrap.TYPE_JSON
    //var xmlData:XML = evt.data;      // if returnType = KivaWrap.TYPE_XML
    //var htmlData:String = evt.data;  // if returnType = KivaWrap.TYPE_HTML

    // ... write your code to process the data here
}

```


#### difference between dispatchModes DISPATCH\_UNIQUE && DISPATCH\_COMPLETE ####
```
/** 
 *  DISPATCH COMPLETE
 *  This method would be used if you want to use one handler for all methods 
 */

kivaAPI.dispatchMode = KivaWrap.DISPATCH_COMPLETE;
// creating this listener will send all result events to the kivaResultsHandler function
kivaAPI.addEventListener ( KivaWrapEvent.COMPLETE, kivaResultsHandler );

// all api calls will send a KivaWrapEvent.COMPLETE event 
kivaAPI.getLenderDetails ( ['lenderID1','lenderID2','lenderID3'] );
kivaAPI.getLoanLenders ( 234524 );

// function to handle all methods
function kivaResultsHandler ( ev:KivaWrapEvent ):void {
    // here we have one function to handle all call but we still need to be able 
    // to tell which method was called that resulted in this dispatch
    // so we can know how to properly read the data.
    // For that we use the reqType property in the 'ev' argument
    
    switch ( ev.reqType ) {
        case KivaWrapEvent.LENDER_DETAILS:
            // your code to handle lender details from ev.data
            break;
        case KivaWrapEvent.LOAN_LENDERS:
            // your code to handle a list of lenders from ev.data
            break;
    }
}

```


```
/** 
 *  DISPATCH UNIQUE
 *  This method would be used if you want to create separate handler functions for
 *  different api calls.  
 *  This is the default method of dispatching and the one I personally prefer.
 */

kivaAPI.dispatchMode = KivaWrap.DISPATCH_UNIQUE;

// create an event listener for getLenderDetails
kivaAPI.addEventListener ( KivaWrapEvent.LENDER_DETAILS, handleLenderDetails );

// create an event listener for getLoanLenders
kivaAPI.addEventListener ( KivaWrapEvent.LOAN_LENDERS, handleLoanLenders );

// call the functions to get the data from KivaAPI
kivaAPI.getLenderDetails ( ['lenderID1','lenderID2','lenderID3'] );
kivaAPI.getLoanLenders ( 234524 );

// function to handle getLenderDetails results
function handleLenderDetails ( ev:KivaWrapEvent ):void {
    // your code to handle lender details from ev.data

}

// function to handle getLoanLenders results
function handleLoanLenders ( ev:KivaWrapEvent ):void {
    // your code to handle a list of lenders from ev.data
}

```

or you can set dispatchMode = KivaWrap.DISPATCH\_BOTH <br />
to dispatch both unique and complete events.


<br />
### Kiva API to as3kiva method map ###

<table cellpadding='0' width='100%' border='0' cellspacing='0'>
<blockquote><tr>
<blockquote><td width='17%'><strong>KivaAPI method</strong></td>
<td width='38%'><strong>KivaWrap.as method</strong></td>
<td width='45%'><strong>KivaWrapEvent.as type variable</strong></td>
</blockquote></tr>
<tr>
<blockquote><td><a href='http://build.kiva.org/api#GET*%7Cjournal_entries%7C:id%7Ccomments'>GET /journal_entries/:id/comments</a></td>
<td>getJournalComments ( journal_id:Number, page:Number = 1 ):void</td>
<td>KivaWrapEvent.JOURNAL_COMMENTS</td>
</blockquote></tr>
<tr>
<blockquote><td><a href='http://build.kiva.org/api#GET*%7Cjournal_entries%7Csearch'>GET /journal_entries/search</a></td>
<td>searchJournals ( page:Number=1, params:Object=null ):void</td>
<td>KivaWrapEvent.JOURNAL_SEARCH</td>
</blockquote></tr>
<tr>
<blockquote><td>------------------------------------------</td>
<td>------------------------------------------------------------------------</td>
<td>------------------------------------------</td>
</blockquote></tr>
<tr>
<blockquote><td><a href='http://build.kiva.org/api#GET*%7Clenders%7C:lender_ids'>GET /lenders/:lender_ids</a></td>
<td>getLenderDetails ( lenders:Array ):void</td>
<td>KivaWrapEvent.LENDER_DETAILS</td>
</blockquote></tr>
<tr>
<blockquote><td><a href='http://build.kiva.org/api#GET*%7Clenders%7C:lender_id%7Cloans'>GET /lenders/:lender_id/loans</a></td>
<td>getLenderLoans ( lenderID:String, page:Number=1, sort:String = KivaWrap.SORT_NEW ):void</td>
<td>KivaWrapEvent.LENDER_LOANS</td>
</blockquote></tr>
<tr>
<blockquote><td><a href='http://build.kiva.org/api#GET*%7Clenders%7C:lender_id%7Cteams'>GET /lenders/:lender_id/teams</a></td>
<td>getLenderTeams ( lenderID:String, page:Number = 1 )</td>
<td>KivaWrapEvent.LENDER_TEAMS</td>
</blockquote></tr>
<tr>
<blockquote><td><a href='http://build.kiva.org/api#GET*%7Clenders%7Cnewest'>GET /lenders/newest</a></td>
<td>getNewestLenders ( page:Number = 1 )</td>
<td>KivaWrapEvent.LENDER_NEWEST</td>
</blockquote></tr>
<tr>
<blockquote><td><a href='http://build.kiva.org/api#GET*%7Clenders%7Csearch'>GET /lenders/search</a></td>
<td>searchLenders ( page:Number = 1,params:Object = null )</td>
<td>KivaWrapEvent.LENDER_SEARCH</td>
</blockquote></tr>
<tr>
<blockquote><td>------------------------------------------</td>
<td>------------------------------------------------------------------------</td>
<td>------------------------------------------</td>
</blockquote></tr>
<tr>
<blockquote><td><a href='http://build.kiva.org/api#GET*%7Clending_actions%7Crecent'>GET /lending_actions/recent</a></td>
<td>getRecentLendingActions ():void</td>
<td>KivaWrapEvent.LEND_ACTIONS</td>
</blockquote></tr>
<tr>
<blockquote><td>------------------------------------------</td>
<td>------------------------------------------------------------------------</td>
<td>------------------------------------------</td>
</blockquote></tr>
<tr>
<blockquote><td><a href='http://build.kiva.org/api#GET*%7Cloans%7C:ids'>GET /loans/:ids</a></td>
<td>getLoanDetails ( ids:Array ):void</td>
<td>KivaWrapEvent.LOAN_DETAILS</td>
</blockquote></tr>
<tr>
<blockquote><td><a href='http://build.kiva.org/api#GET*%7Cloans%7C:id%7Cjournal_entries'>GET /loans/:id/journal_entries</a></td>
<td>getLoanJournal ( loanID:Number, include_bulk:Boolean = true, page:Number = 1 ):void</td>
<td>KivaWrapEvent.LOAN_JOURNAL</td>
</blockquote></tr>
<tr>
<blockquote><td><a href='http://build.kiva.org/api#GET*%7Cloans%7C:id%7Clenders'>GET /loans/:id/lenders</a></td>
<td>getLoanLenders ( loanID:Number, page:Number ):void</td>
<td>KivaWrapEvent.LOAN_LENDERS</td>
</blockquote></tr>
<tr>
<blockquote><td><a href='http://build.kiva.org/api#GET*%7Cloans%7C:id%7Cupdates'>GET /loans/:id/updates</a></td>
<td>getLoanUpdates ( loanID:Number  ):void</td>
<td>KivaWrapEvent.LOAN_UPDATES</td>
</blockquote></tr>
<tr>
<blockquote><td><a href='http://build.kiva.org/api#GET*%7Cloans%7Cnewest'>GET /loans/newest</a></td>
<td>getNewestLoans (page:Number = 1 ):void</td>
<td>KivaWrapEvent.LOAN_NEWEST</td>
</blockquote></tr>
<tr>
<blockquote><td><a href='http://build.kiva.org/api#GET*%7Cloans%7Csearch'>GET /loans/search</a></td>
<td>searchLoans ( page:Number = 1,params:Object = null ):void</td>
<td>KivaWrapEvent.LOAN_SEARCH</td>
</blockquote></tr>
<tr>
<blockquote><td>------------------------------------------</td>
<td>------------------------------------------------------------------------</td>
<td>------------------------------------------</td>
</blockquote></tr>
<tr>
<blockquote><td><a href='http://build.kiva.org/api#GET*%7Cpartners'>GET /partners</a></td>
<td>getPartnersList (page:Number=1):void</td>
<td>KivaWrapEvent.PARTNERS_LIST</td>
</blockquote></tr>
<tr>
<blockquote><td>------------------------------------------</td>
<td>------------------------------------------------------------------------</td>
<td>------------------------------------------</td>
</blockquote></tr>
<tr>
<blockquote><td><a href='http://build.kiva.org/api#GET*%7Cteams%7C:ids'>GET /teams/:ids</a></td>
<td>getTeamDetails ( teamIDs:Array ):void</td>
<td>KivaWrapEvent.TEAM_DETAILS</td>
</blockquote></tr>
<tr>
<blockquote><td><a href='http://build.kiva.org/api#GET*%7Cteams%7C:id%7Clenders'>GET /teams/:id/lenders</a></td>
<td>getTeamLenders ( teamID:Number, page:Number=1, sort:String = KivaWrap.SORT_NEW ):void</td>
<td>KivaWrapEvent.TEAM_LENDERS</td>
</blockquote></tr>
<tr>
<blockquote><td><a href='http://build.kiva.org/api#GET*%7Cteams%7C:id%7Cloans'>GET /teams/:id/loans</a></td>
<td>getTeamLoans ( teamID:Number, page:Number = 1, sort:String = KivaWrap.SORT_NEW ):void</td>
<td>KivaWrapEvent.TEAM_LOANS</td>
</blockquote></tr>
<tr>
<blockquote><td><a href='http://build.kiva.org/api#GET*%7Cteams%7Csearch'>GET /teams/search</a></td>
<td>searchTeams ( page:Number = 1, params:Object = null )</td>
<td>KivaWrapEvent.TEAM_SEARCH</td>
</blockquote></tr>
<tr>
<blockquote><td><a href='http://build.kiva.org/api#GET*%7Cteams%7Cusing_shortname%7C:shortnames'>GET /teams/using_shortname/:shortnames</a></td>
<td>getTeamDetailsByShortname ( names:Array ):void</td>
<td>KivaWrapEvent.TEAM_DETAILS_BYNAME</td>
</blockquote></tr>
</table></blockquote>


<br />

### Additional Methods and Properties ###

KivaWrap.getImageURL ( imageID:Number, size:String = KivaWrap.IMG\_200x200 ):String<br />
Provided an imageID and a KivaAPI approved image size, the function returns the URL to access the image from Kiva.<br />
The approved image sizes have been provided as static constants in the KivaWrap class<br />
KivaWrap.IMG\_80x80<br />
KivaWrap.IMG\_200x200<br />
KivaWrap.IMG\_325x250<br />
KivaWrap.IMG\_450x360<br />
KivaWrap.IMG\_FULLSIZE<br />
```
import com.humsara.kiva.KivaWrap;
var myImageURL:String = KivaWrap.getImageURL ( 9381, KivaWrap.IMG_FULLSIZE);
```

<br /><br />
**other static variables of KivaWrap.as**
```
public static const TYPE_XML:String = "xml";
public static const TYPE_JSON:String = "json";
public static const TYPE_HTML:String = "html";
public static const SORT_NEW:String = "newest";
public static const SORT_OLD:String = "oldest";
public static const SORT_POPULARITY:String = "popularity";
public static const SORT_LOAN_AMOUNT:String = "loan_amount";
public static const SORT_EXPIRATION:String = "expiration";
public static const SORT_AMOUNT_REM:String = "amount_remaining";
public static const SORT_REPAYMENT_T:String = "repayment_term";
public static const SORT_RECOMMENDATION_C = "recommendation_count";
public static const SORT_COMMENT_C = "comment_count"
public static const MEDIA_ANY = "any";
public static const MEDIA_VIDEO = "video";
public static const MEDIA_IMAGE = "image";
public static const STATUS_FUNDRAISING = "fundraising";
public static const STATUS_FUNDED = "funded";
public static const STATUS_IN_REPAYMENT = "in_repayment";
public static const STATUS_PAID = "paid";
public static const STATUS_DEFAULTED= "defaulted";

```
<br /><br />
### Search Methods : "params" parameter explaination ###
There are four methods for searching data from the api.  searchJournals, searchLenders, searchLoans, and searchTeams.  Each of these search functions accepts a pageNumber as its first argument, and an object containing additional search parameters as allowed by the kiva api.<br />
The accepted variables in the params object are the same as those specified in the KivaAPI documentation.<br />Please refer to the linked references to the KivaAPI for acceptable values for each parameter and further details.<br />
I have created static variables for some of the values I found myself using the most, like SORT\_NEW,SORT\_OLD etc.. for the 'sort\_by' parameter, or STATUS\_FUNDRAISING, STATUS\_PAID etc for the 'status'  parameter

searchJournals ( page:Number=1, params:Object=null )<br />
  * [params](http://build.kiva.org/api#GET*|journal_entries|search): q,sort\_by,media,include\_bulk,partner
searchLenders ( page:Number=1, params:Object=null )<br />
  * [params](http://build.kiva.org/api#GET*|lenders|search): q,sort\_by,country\_code,occupation
searchLoans ( page:Number=1, params:Object=null )<br />
  * [params](http://build.kiva.org/api#GET*|loans|search): q,sort\_by,status,gender,region,country\_code,sector,partner,has\_currency\_loss
searchTeams ( page:Number=1, params:Object=null )<br />
  * [params](http://build.kiva.org/api#GET*|teams|search): q,sort\_by,membership\_type,category

<br />**Sample usage for searchLoans**
```
var searchParams:Object = { sort_by:KivaWrap.SORT_AMOUNT_REM, region:["ca","sa"],has_currency_loss:false };
kivaAPI.searchLoans(1,searchParams);
```