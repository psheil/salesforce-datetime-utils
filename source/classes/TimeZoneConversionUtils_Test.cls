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


@isTest 
private class TimeZoneConversionUtils_Test {
    static testMethod void testConversion() {
        Date_Time_Fields_To_Convert__c dtfToConvert = new Date_Time_Fields_To_Convert__c
            (Name = 'Test Conversion',
             Object_API_Name__c = 'Contact',
             Source_Field_API_Name__c = 'CreatedDate',
             Target_Field_API_Name__c = 'FirstName',
             Offset_Field_API_Name__c = 'Title');
        insert dtfToConvert;
        
        Contact c = new Contact();
        list<Contact> cs = new list<Contact>([select id from Contact limit 1]);
        if(!cs.isEmpty()) {
            c = cs[0];
        }
        
        c.LastName = 'Test Contact';
        c.Title = 'America/Los_Angeles';

        upsert c;
        
        TimeZoneConversionUtils.convertTimeZoneFields(new list<Id>{c.Id});
        
        c = [select id, FirstName, Title, CreatedDate from Contact where Id = :c.Id limit 1];
        string expectedValue = c.CreatedDate.format('dd-MM-YYYY HH:mm:ss EEEE', c.Title);
        system.assertEquals(expectedValue,c.FirstName);
    }
}