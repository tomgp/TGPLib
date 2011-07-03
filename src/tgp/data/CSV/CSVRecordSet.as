package tgp.data.CSV
{
	public class CSVRecordSet
	{
		public var rows:Array;
		public var fields:Array;
		private var _defaultIndex:String;
		
		private var lookups:Array = [];
		
		private var currentRow:int = 0;
		
		private var indices:Array = [];
		
		public function CSVRecordSet(CSVString:String ="", defaultIndex:String = "")
		{
			if(CSVString != ""){
				_defaultIndex = defaultIndex;
				rows = CSVParser.parse(CSVString);
				createFieldsArray();
				if(_defaultIndex != ""){
					createIndex(_defaultIndex);
				}
			}
		}
		
		public function addField(fieldName:String):void{
			//check iof the field exists
			if(fields.indexOf(fieldName) == -1){
				fields.push(fieldName); //if it doesn't push it onto the field list
			}
		}
		
		private function createFieldsArray():void{
			fields = [];
			var o:Object = rows[0];
			for(var header:String in o){
				fields.push(header);
			}
		}
		

		
		public function setRows(records:Array):void{
			rows = records;
			createFieldsArray();
		}
		
		public function sortBy(index:String, options:Object):void{
			rows.sortOn(index, options);
			reIndex(); //recreate the lookups as sorting will have made them all wrong
		}
		
		private function reIndex():void{
			trace("re-indexing record set");
			lookups = [];
			for(var index:String in  indices){
				trace(" + " + index);
				createIndex(index);
			}
		}
		
		public function createIndex(column:String):void{
			
			if(indices.indexOf(column) == -1){
				indices.push(column);
			}
			
			indices.push(column);
			if(lookups[column]){
				trace("warning lookup already exists. Overwriting");
			}
			lookups[column] = [];
			for each(var o:Object in rows){
				try{
					lookups[column][o[column]] = o;
				}catch(err:Error){
					trace(err);
				}
			}
		}
		
		public function getItem(column:String, identifier:String):Object{
			return lookups[column][identifier];
		}
		
		public function toString():String{
			//the column headers
			var s:String = "";
			for each(var field:String in fields){
				s += "\"" + field + "\",";
			}
			s += "\n";
			
			//go through each record and print it as a CSV line
			for each (var row:Object in rows){
				for each(field in fields){
					try{
						s += "\"" +row[field] + "\",";
					}catch(err:Error){
						s += ",";
					}
				}
				s += "\n";
			}
		
			return s;
		}
	}
}