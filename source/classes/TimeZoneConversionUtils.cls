/* 
The MIT License (MIT)

Copyright (c) 2015 Patrick Sheil

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/


public class TimeZoneConversionUtils {

    @InvocableMethod
    public static list<id> convertTimeZoneFields(list<id> idsOfRecords) {
        // get the object type for the first element in the list
		string sObjectName = idsOfRecords[0].getSObjectType().getDescribe().getName();
        system.debug('sObjectName: ' + sObjectName);
        
        // get the definitions of which fields to convert from the custom setting
        List<Date_Time_Fields_To_Convert__c > dtFieldsToConvert = Date_Time_Fields_To_Convert__c.getall().values(); 
        system.debug('dtFieldsToConvert: ' + dtFieldsToConvert);
        
        // construct the set of fields to query
        set<string> fieldsToQuery = new set<String>();
        
        // construct a new map of target field names to conversion settings records
        map<string,Date_Time_Fields_To_Convert__c> conversionSettings = new map<string,Date_Time_Fields_To_Convert__c>();
        for(Date_Time_Fields_To_Convert__c dtFieldToConvert : dtFieldsToConvert) {
            if(dtFieldToConvert.Object_API_Name__c == sObjectName) {                
                fieldsToQuery.add(dtFieldToConvert.Source_Field_API_Name__c);
                fieldsToQuery.add(dtFieldToConvert.Target_Field_API_Name__c);
                fieldsToQuery.add(dtFieldToConvert.Offset_Field_API_Name__c);
                conversionSettings.put(dtFieldToConvert.Target_Field_API_Name__c, dtFieldToConvert);
            }
        }
        system.debug('fieldsToQuery: ' + fieldsToQuery);
        
        // create query string using all the fields from the set created above
        string queryString = 'select id';
        for(string fieldToQuery : fieldsToQuery) {
            queryString += ', ' + fieldToQuery;
        }
        queryString += 	' from ' + sObjectName + ' where id in :idsOfRecords';
        system.debug('queryString: ' + queryString);
        
        list<sObject> records = database.query(queryString);
		system.debug('records: ' + records);
        
        for(sObject record : records) {
            for(string targetField : conversionSettings.keyset()) {
                dateTime gmtDateTime;
                string timeZone;
                string localDateTime;
                
                if((DateTime)record.get(conversionSettings.get(targetField).Source_Field_API_Name__c) == null ||
                   (string)record.get(conversionSettings.get(targetField).Offset_Field_API_Name__c) == null ) {
                       record.put(targetField, null);
                       continue;
                	}
                
                gmtDateTime = (DateTime)record.get(conversionSettings.get(targetField).Source_Field_API_Name__c);                    
                timeZone = (string)record.get(conversionSettings.get(targetField).Offset_Field_API_Name__c);

                localDateTime = gmtDateTime.format('dd-MM-yyyy HH:mm:ss EEEE', timeZone);

                record.put(targetField, localDateTime);
            }
        }
        
        system.debug(records);
        update records;
        return new list<id>();
    }    
}
