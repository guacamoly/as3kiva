﻿/**
 * The MIT License
 * Copyright (c) 2010, Amol Mittal
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.humsara.kiva 
{
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class KivaWrap extends EventDispatcher
	{
		
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
		public static const SORT_RECOMMENDATION_C:String = "recommendation_count";
		public static const SORT_COMMENT_C:String = "comment_count"
		public static const MEDIA_ANY:String = "any";
		public static const MEDIA_VIDEO:String = "video";
		public static const MEDIA_IMAGE:String = "image";
		public static const STATUS_FUNDRAISING:String = "fundraising";
		public static const STATUS_FUNDED:String = "funded";
		public static const STATUS_IN_REPAYMENT:String = "in_repayment";
		public static const STATUS_PAID:String = "paid";
		public static const STATUS_DEFAULTED:String = "defaulted";
		
		public static const IMG_80x80:String = "w80h80";
		public static const IMG_200x200:String = "w200h200"; // default
		public static const IMG_325x250:String = "w325h250";
		public static const IMG_450x360:String = "w450h360";
		public static const IMG_FULLSIZE:String = "fullsize";
		
		public static const IMG_URL_TMPL:String = "http://www.kiva.org/img/<size>/<id>.jpg"
		public static const API_BASE_URL:String = "http://api.kivaws.org/v1";
		
		// dispatch KivaWrapEvent of types associated to each method   - DEFAULT
		public static const DISPATCH_UNIQUE:String = "dispatchUnique";
		// dispatch KivaWrapEvent of type "COMPLETE" for all methods
		public static const DISPATCH_COMPLETE:String = "dispatchComplete";
		// dispatch both UNIQUE types and COMPLETE types for all methods
		public static const DISPATCH_BOTH:String = "dispatchBoth";
		
		// changeable properties
		private var _appID:String = "com.humsara.as3.kivaAPIwrap";
		private var _returnType:String = TYPE_JSON;
		private var _dispatchMode:String = DISPATCH_UNIQUE;
		public var formatResult:Boolean = true;
		
		public function KivaWrap() 
		{
		}
		
		private function dispatchHelper ( data:String, type:String ):void  {
			if ( dispatchMode == KivaWrap.DISPATCH_COMPLETE || dispatchMode == KivaWrap.DISPATCH_BOTH ) {
				var ev:KivaWrapEvent = new KivaWrapEvent( KivaWrapEvent.COMPLETE );
				ev.reqType = type;
				formatToTypeAndDispatch(ev, data);
			}
			
			if ( dispatchMode == KivaWrap.DISPATCH_UNIQUE || dispatchMode == KivaWrap.DISPATCH_BOTH ) {
				var ev2:KivaWrapEvent = new KivaWrapEvent ( type );
				ev2.reqType = type;
				formatToTypeAndDispatch (ev2, data);
			}
		}
		
		// creates a standard web url for the imageID provided
		public static function getImageURL ( imageID:Number, size:String = KivaWrap.IMG_200x200 ):String
		{
			var str:String = IMG_URL_TMPL.replace("<id>", String(imageID)).replace("<size>", size);
			return str;
		}
		
		/**
		 * GET /lenders/:lender_ids
		 * Retrieves detail for multiple lenders.
		 * http://api.kivaws.org/v1/lenders/matt.html
		 * @param	lenders
		 */
		public function getLenderDetails ( lenders:Array ):void {
			var args:String = "?appID="+appID;
			var url:String = API_BASE_URL + "/lenders/" + lenders.toString() + "." + returnType + args;
			
			trace ( "KivaWrap::getLenderDetails:: " + url);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener (Event.COMPLETE, onGetLenderDetails);
			
			loader.load( new URLRequest(url));
		}
		
		private function onGetLenderDetails ( e:Event ):void {
			var data:String = e.target.data;
			
			dispatchHelper(data, KivaWrapEvent.LENDER_DETAILS);
		}
		
		/**
		 * GET /lenders/:lender_id/loans
		 * Returns loans belonging to a particular lender.
		 * http://api.kivaws.org/v1/lenders/jeremy/loans.json
		 * @param	lenderID
		 * @param	page
		 * @param	sort
		 */
		public function getLenderLoans ( lenderID:String, page:Number=1, sort:String = KivaWrap.SORT_NEW ):void {
			var args:String = "?page=" + page + "&sort=" + sort + "&appID="+appID;
			var url:String = API_BASE_URL + "/lenders/" + lenderID + "/loans." + returnType + args;
			
			trace ( "KivaWrap::getLenderLoans:: " + url);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener (Event.COMPLETE, onGetLenderLoans);
			
			loader.load( new URLRequest(url));
		}
		private function onGetLenderLoans ( e:Event ):void {
			// get data from api call
			var data:String = e.target.data;
			dispatchHelper(data, KivaWrapEvent.LENDER_LOANS);
		}
		
		/**
		 * GET /lenders/:lender_id/teams
		 * Returns teams that a particular lender is a member of.
		 * http://api.kivaws.org/v1/lenders/jeremy/teams.json
		 * @param	lenderID
		 * @param	page
		 */
		public function getLenderTeams ( lenderID:String, page:Number = 1 ):void {
			var args:String = "?page=" + page + "&appID="+appID;;
			var url:String = API_BASE_URL + "/lenders/" + lenderID + "/teams." + returnType + args;
			
			trace ( "KivaWrap::getLenderTeams:: " + url);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener (Event.COMPLETE, onGetLenderTeams);
			
			loader.load( new URLRequest(url));
		}
		private function onGetLenderTeams ( e:Event ):void {
			var data:String = e.target.data;
			dispatchHelper(data, KivaWrapEvent.LENDER_TEAMS);
		}
		
		/**
		 * GET /lenders/newest
		 * Returns listings for the lenders who have most recently joined Kiva.
		 * http://api.kivaws.org/v1/lenders/newest.json
		 * @param	page
		 */
		public function getNewestLenders ( page:Number = 1 ):void {
			var args:String = "?page=" + page + "&appID="+appID;;
			var url:String = API_BASE_URL + "/lenders/newest." + returnType + args;
			
			trace ( "KivaWrap::getLendersNewest:: " + url);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener (Event.COMPLETE, onGetNewestLenders);
			loader.load( new URLRequest(url));
		}
		private function onGetNewestLenders ( e:Event ):void {
			var data:String = e.target.data;
			dispatchHelper(data, KivaWrapEvent.LENDER_NEWEST);
		}
		
		/**
		 * GET /lenders/search
		 * Search and sort lender listings based on multiple criteria.
		 * http://api.kivaws.org/v1/lenders/search.json
		 * @param	page
		 * @param	params : q,sort_by,country_code,occupation
		 */
		public function searchLenders ( page:Number = 1,params:Object = null ):void{
			var args:String = "?page=" + page + "&appID="+appID;
			if ( params != null ) {
				for ( var i:String in params ) {
					switch ( i ) {
						case "country_code":
							args += "&" + i + "=" + params[i].toString();
							break;
						default:
							args += "&" + i + "=" + params[i];
					}
				}
			}
					
			var url:String = API_BASE_URL + "/lenders/search." + returnType + args;
			
			trace ( "KivaWrap::getLendersSearch:: " + url);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener (Event.COMPLETE, onGetLendersSearch);
			loader.load( new URLRequest(url));
		}
		private function onGetLendersSearch ( e:Event ):void {
			var data:String = e.target.data;
			dispatchHelper(data, KivaWrapEvent.LENDER_SEARCH);
		} 
		
		/**
		 * 
		 * @param	ids
		 */
		public function getLoanDetails ( ids:Array ):void {
			var url:String = API_BASE_URL + "/loans/"+ ids.toString() +"."+ returnType  + "?appID="+appID
			trace ( "KivaWrap::getLoanDetails:: " + url);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener (Event.COMPLETE, onGetLoanDetails);
			loader.load( new URLRequest(url));
		}
		private function onGetLoanDetails ( e:KivaWrapEvent ):void {
			var data:String = e.target.data;
			dispatchHelper(data, KivaWrapEvent.LOAN_DETAILS);
		}
		
		/**
		 * 
		 * @param	loanID
		 * @param	include_bulk
		 * @param	page
		 */
		public function getLoanJournal ( loanID:Number, include_bulk:Boolean = true, page:Number = 1 ):void {
			var args:String = "?page=" + page + "&include_bulk=" + (include_bulk?'1':'0') + "&appID="+appID;
			var url:String = API_BASE_URL + "/loans/" + loanID + "/journal_entries." + returnType + args;
			trace ( "KivaWrap::getLoanJournal:: " + url);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener (Event.COMPLETE, onGetLoanJournal);
			loader.load( new URLRequest(url));
		}
		private function onGetLoanJournal ( e:Event ):void  {
			var data:String = e.target.data;
			dispatchHelper(data, KivaWrapEvent.LOAN_JOURNAL);
		}
		
		/**
		 * 
		 * @param	loanID
		 * @param	page
		 */
		public function getLoanLenders ( loanID:Number, page:Number ):void {
			var args:String = "?page=" + page + "&appID="+appID;
			var url:String = API_BASE_URL + "/loans/" + loanID + "/lenders." + returnType + args;
			trace ( "KivaWrap::getLoanLenders:: " + url);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener (Event.COMPLETE, onGetLoanLenders);
			loader.load( new URLRequest(url)); 
		}
		private function onGetLoanLenders ( e:Event ):void  {
			var data:String = e.target.data;
			dispatchHelper(data, KivaWrapEvent.LOAN_LENDERS);
		}
		
		/**
		 * 
		 * @param	loanID
		 */
		public function getLoanUpdates ( loanID:Number  ):void {
			var url:String = API_BASE_URL + "/loans/" + loanID + "/updates." + returnType + "?appID="+appID;
			var loader:URLLoader = new URLLoader();
			trace ( "KivaWrap::getLoanUpdates:: " + url);
			loader.addEventListener (Event.COMPLETE, onGetLoanUpdates);
			loader.load( new URLRequest(url)); 
		}
		private function onGetLoanUpdates ( e:Event ):void  {
			var data:String = e.target.data;
			dispatchHelper(data, KivaWrapEvent.LOAN_UPDATES);
		}
		
		
		/**
		 * 
		 * @param	page
		 */
		public function getNewestLoans (page:Number = 1 ):void {
			var url:String = API_BASE_URL + "/loans/newest." + returnType + "?appID="+appID;
			var loader:URLLoader = new URLLoader();
			trace ( "KivaWrap::getLoansNewest:: " + url);
			loader.addEventListener (Event.COMPLETE, onGetLoansNewest);
			loader.load( new URLRequest(url)); 
		}
		private function onGetLoansNewest ( e:Event ):void  {
			var data:String = e.target.data;
			dispatchHelper(data, KivaWrapEvent.LOAN_NEWEST);
		}
		
		
		/**
		 * 
		 * @param	page
		 * @param	params  status,gender,region,country_code,sector,partner,sort_by,q,has_currency_loss
		 */
		public function searchLoans ( page:Number = 1,params:Object = null ):void {
			var args:String = "?page=" + page + "&appID="+appID;
			if ( params != null ) {
				for ( var i:String in params ) {
					switch ( i ) {
						case "region":
						case "country_code":
						case "sector":
						case "partner":
							args += "&" + i + "=" + params[i].toString();
							break;
						case "has_currency_loss":
							args += "&" + i + "=" + (params[i] ? '1':'0');
							break;
						default:
							args += "&" + i + "=" + params[i];
					}
				}
			}
			var url:String = API_BASE_URL + "/loans/search." + returnType + args;
			trace ( "KivaWrap::getLoansSearch:: " + url);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener (Event.COMPLETE, onGetLoansSearch);
			loader.load( new URLRequest(url)); 
		}
		private function onGetLoansSearch ( e:Event ):void  {
			var data:String = e.target.data;
			dispatchHelper(data, KivaWrapEvent.LOAN_SEARCH);
		}
		
		
		/**
		 * 
		 * @param	journal_id
		 * @param	page
		 */
		public function getJournalComments ( journal_id:Number, page:Number = 1 ):void {
			var args:String = "?page=" + page + "&appID="+appID;
			var url:String = API_BASE_URL + "/journal_entries/"+journal_id+"/comments." + returnType + args;
			trace ( "KivaWrap::getJournalComments:: " + url);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener (Event.COMPLETE, onGetJournalComments);
			loader.load( new URLRequest(url)); 
		}
		private function onGetJournalComments ( e:Event ):void  {
			var data:String = e.target.data;
			dispatchHelper(data, KivaWrapEvent.JOURNAL_COMMENTS);
		}
		
		
		/**
		 * 
		 * @param	page
		 * @param	params -> media,include_bulk,partner,sort_by,q
		 */
		public function searchJournals ( page:Number=1, params:Object=null ):void {
			var args:String = "?page=" + page + "&appID="+appID;
			if ( params != null ) {
				for ( var i:String in params ) {
					switch ( i ) {
						case "partner":
							args += "&" + i + "=" + params[i].toString();
							break;
						case "include_bulk":
							args += "&" + i + "=" + (params[i] ? '1':'0');
							break;
						default:
							args += "&" + i + "=" + params[i];
					}
				}
			}
			var url:String = API_BASE_URL + "/journal_entries/search." + returnType + args;
			trace ( "KivaWrap::getJournalSearch:: " + url);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener (Event.COMPLETE, onGetJournalSearch);
			loader.load( new URLRequest(url)); 
		}
		private function onGetJournalSearch ( e:Event ):void {
			var data:String = e.target.data;
			dispatchHelper(data, KivaWrapEvent.JOURNAL_SEARCH);
		}
		
		
		/**
		 * 
		 */
		public function getRecentLendingActions ():void {
			var url:String = API_BASE_URL + "/lending_actions/recent." + returnType + "?appID="+appID;
			trace ( "KivaWrap::getRecentLendingActions:: " + url);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener (Event.COMPLETE, onGetRecentLendingActions);
			loader.load( new URLRequest(url));
		}
		private function onGetRecentLendingActions (e:Event):void {
			var data:String = e.target.data;
			dispatchHelper(data, KivaWrapEvent.LEND_ACTIONS);
		}
		
		
		/**
		 * 
		 * @param	page
		 */
		public function getPartnersList (page:Number=1):void {
			var url:String = API_BASE_URL + "/partners." + returnType + "?page="+page + "&appID="+appID;
			trace ( "KivaWrap::getPartnersList:: " + url);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener (Event.COMPLETE, onGetPartnersList);
			loader.load( new URLRequest(url));
		}
		private function onGetPartnersList (e:Event):void {
			var data:String = e.target.data;
			dispatchHelper(data, KivaWrapEvent.PARTNERS_LIST);
		}
		
		/**
		 * 
		 * @param	teamIDs array of teamID's max length 20
		 */
		public function getTeamDetails ( teamIDs:Array ):void {
			
			var url:String = API_BASE_URL + "/teams/" + teamIDs.toString() + "." + returnType  + "?appID="+appID;;
			trace ( "KivaWrap::getTeamDetails:: " + url);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener (Event.COMPLETE, onGetTeamDetails);
			loader.load( new URLRequest(url));
		}
		private function onGetTeamDetails (e:Event):void {
			var data:String = e.target.data;
			dispatchHelper(data, KivaWrapEvent.TEAM_DETAILS);
		}
		
		
		/**
		 * 
		 * @param	teamID
		 * @param	page
		 * @param	sort
		 */
		public function getTeamLenders ( teamID:Number, page:Number=1, sort:String = KivaWrap.SORT_NEW ):void {
			var args:String = "?page=" + page + "&sort=" + sort + "&appID="+appID;
			var url:String = API_BASE_URL + "/teams/" + String(teamID) + "/lenders." + returnType + args;
			trace ( "KivaWrap::getTeamLenders:: " + url);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener (Event.COMPLETE, onGetTeamLenders);
			loader.load( new URLRequest(url));
		}
		private function onGetTeamLenders (e:Event):void {
			var data:String = e.target.data;
			dispatchHelper(data, KivaWrapEvent.TEAM_LENDERS);
		}
		
		/**
		 * 
		 * @param	teamID
		 * @param	page
		 * @param	sort
		 */
		public function getTeamLoans ( teamID:Number, page:Number = 1, sort:String = KivaWrap.SORT_NEW ):void {
			var args:String = "?page=" + page + "&sort=" + sort + "&appID=" + appID;
			var url:String = API_BASE_URL + "/teams/" + String(teamID) + "/loans." + returnType + args;
			trace ( "KivaWrap::getTeamLoans:: " + url);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener (Event.COMPLETE, onGetTeamLoans);
			loader.load( new URLRequest(url));
		}
		private function onGetTeamLoans (e:Event):void {
			var data:String = e.target.data;
			dispatchHelper(data, KivaWrapEvent.TEAM_LOANS);
		}
		
		/**
		 * 
		 * @param	page
		 * @param	params : membership_type,category,sort_by,q
		 */
		public function searchTeams ( page:Number = 1, params:Object = null ):void {
			var args:String = "?page=" + page + "&appID="+appID;
			if ( params != null ) {
				for ( var i:String in params ) {
					args += "&" + i + "=" + params[i];
				}
			}
			var url:String = API_BASE_URL + "/teams/search." + returnType + args;
			trace ( "KivaWrap::getTeamSearch:: " + url);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener (Event.COMPLETE, onGetTeamsSearch);
			loader.load( new URLRequest(url)); 
		}
		private function onGetTeamsSearch ( e:Event ):void  {
			var data:String = e.target.data;
			dispatchHelper(data, KivaWrapEvent.TEAM_SEARCH);
		}
		
		/**
		 * 
		 * @param	names
		 */
		public function getTeamDetailsByShortname ( names:Array ):void {
			var args:String = "?appID=" + appID;
			var url:String = API_BASE_URL + "/teams/using_shortname/" + names.toString() + "." + returnType + args;
			trace ( "KivaWrap::getTeamDetailsByShortname:: " + url);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener (Event.COMPLETE, onGetTeamDetailsByShortname);
			loader.load( new URLRequest(url)); 
		}
		private function onGetTeamDetailsByShortname ( e:Event ):void  {
			var data:String = e.target.data;
			dispatchHelper(data, KivaWrapEvent.TEAM_DETAILS_BYNAME);
		}
		
		
		private function formatToTypeAndDispatch ( ev:KivaWrapEvent, data:String ):void {
			
			switch ( returnType ) {
				case TYPE_JSON:
					ev.format = TYPE_JSON;
					ev.data = formatResult ? JSON.decode(data) : data;
				break;
				
				case TYPE_HTML:
					ev.format = TYPE_HTML;
					ev.data = data;
				break;
				
				case TYPE_XML:
					ev.format = TYPE_XML;
					ev.data = formatResult ? new XML(data) : data;
				break;
			}
			
			dispatchEvent( ev );
		}
		
		public function set appID (value:String):void {
			_appID = appID;
		}
		public function get appID():String { return _appID; }
		
		public function set returnType (value:String):void {
			_returnType = value;
		}
		public function get returnType ():String { return _returnType; }
		
		public function set dispatchMode (value:String):void {
			_dispatchMode = value;
		}
		public function get dispatchMode():String { return _dispatchMode; }
	}

}