package bbc.news.utils
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	* CSVParser is a utility class that parses a CSV formatted file into an Array of Actionscript objects.
	* The headings of the CSV file are used as the propery names of the object
	*/
	public class CSVParser
	{		
		
		//the regular expression which parses each line, courtesy of OReiley pocket reg exp book
		public static function parse(csv:String, debug:Boolean = false):Array{
			var _columnHeaders:Array = [];
			
			var count:int = 0;
			var dataArray:Array = csv.split( "\n" );
			var length:int = dataArray.length;	
			var first:Boolean = true;			
			var result:Array = [];
			
			for each(var line:String in dataArray){
				line = chomp(line);
				if (first){ //the first line is assumed to be column headers
					_columnHeaders = line.split(/(?:,|^)([^",]+|"(?:[^"]|"")*")?/g);
					first = false;
				}else{					
					//for each line this splits it up into it's comma separated componennts 
					//and stuffs them in an object based on the extracted column headers
					var row:Object = {};
					var tempValues:Array = line.split(/(?:,|^)([^",]+|"(?:[^"]|"")*")?/g);
					var empty:Boolean = true;
					for(var i:int = 0; i<_columnHeaders.length; i++){
						if(_columnHeaders[i]){
							row[_columnHeaders[i]] = cleanQuotes(String(tempValues[i]));
							if( row[_columnHeaders[i]] != "undefined" ){
								empty = false;
							}
						}
					}
					if(!empty){
						result.push(row);
					}
				}
			}  
			if(debug){
				testPrint(result);
			}
			return result;
		}		
		
		//get rid of trailing newlines, all lines MUST!!!! be on one line
		private static function chomp(str:String):String{
			return str.split("\n")[0].split("\r")[0];
		}
		
		//function to print out the contents of parsed array
		private static function testPrint(a:Array):void{
			trace("CSV: ");
			for each(var o:Object in  a){
				trace("	{");
				for(var key:String in o){
					trace( "		" + key + ": " + o[key] );
				} 
				trace("	}");
			}
		}
		
		//beware flaky sourcecode highlighting in this funtion!
		//this function cleans up double quotes left over from the CSV parsing reg exp
		private static function cleanQuotes(str:String):String{
			str = str.replace(/""/g, '%%DOUBLE_QUOTE_PLACE_HOLDER%%');
			str = str.replace(/"/g,'');  
			// " commment to close the flaky source code highlighting
			str = str.replace(/%%DOUBLE_QUOTE_PLACE_HOLDER%%/g,'"');
			return str;
		} 		
	}
}