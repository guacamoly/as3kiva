/**
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
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 
	 */
	public class KivaWrapEvent extends Event 
	{
		public var data:*;
		public var format:String;
		
		public static const LENDER_DETAILS:String = "lenderDetails";
		public static const LENDER_LOANS:String = "lenderLoans";
		public static const LENDER_TEAMS:String = "lenderTeams";
		public static const LENDER_NEWEST:String = "lenderNewest";
		public static const LENDER_SEARCH:String = "lenderSearch";
		public static const LOAN_DETAILS:String = "loanDetails";
		public static const LOAN_JOURNAL:String = "loanJournal";
		public static const LOAN_LENDERS:String = "loanLenders";
		public static const LOAN_UPDATES:String = "loanUpdates";
		public static const LOAN_NEWEST:String = "loanNewest";
		public static const LOAN_SEARCH:String = "loanSearch";
		public static const JOURNAL_COMMENTS:String = "journalComments";
		public static const JOURNAL_SEARCH:String = "journalSearch";
		public static const LEND_ACTIONS:String = "lendingActions";
		public static const PARTNERS_LIST:String = "partnersList";
		public static const TEAM_DETAILS:String = "teamDetails";
		public static const TEAM_LENDERS:String = "teamLenders";
		public static const TEAM_LOANS:String = "teamLoans";
		public static const TEAM_SEARCH:String = "teamSearch";
		public static const TEAM_DETAILS_BYNAME:String = "teamDetailsByName";
		
		public function KivaWrapEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new KivaWrapEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("KivaWrapEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}